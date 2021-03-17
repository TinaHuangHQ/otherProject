//
//  NSObject+HQKVC.m
//  KCVDemo
//
//  Created by macbook pro on 2021/3/17.
//

#import "NSObject+HQKVC.h"
#import <objc/runtime.h>

@implementation NSObject (HQKVC)

-(BOOL)hq_performSelectorWithMethodName:(NSString *)methodName value:(id)value{
    BOOL result = [self respondsToSelector:NSSelectorFromString(methodName)];
    if(result){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(methodName) withObject:value];
#pragma clang diagnostic pop
    }
    return result;
}

- (id)hq_performSelectorWithMethodName:(NSString *)methodName{
    BOOL result = [self respondsToSelector:NSSelectorFromString(methodName)];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if(result){
        return [self performSelector:NSSelectorFromString(methodName)];
    }
#pragma clang diagnostic pop
    return nil;
}

- (NSArray*)getIvarListName{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    unsigned int outCount = 0;
    Ivar* ivars = class_copyIvarList(self.class, &outCount);
    for(int i = 0; i<outCount; i++){
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString* ivarName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        [arr addObject:ivarName];
    }
    
    free(ivars);
    return arr;
}

//set<Key> --> _set<Key> --> setIs<Key>
- (void)hq_setValue:(id)value forKey:(NSString *)key{
    if (key == nil || key.length == 0) {
        return;
    }
    //将key值的首字符变成大写，为后续补充set做准备
    NSString* Key = [key capitalizedString];
    //拼接setKey方法名
    NSString* setKey = [[NSString alloc] initWithFormat:@"set%@:", Key];
    //拼接_setKey方法名
    NSString* _setKey = [[NSString alloc] initWithFormat:@"_set%@:", Key];
    //拼接setIsKey方法名
    NSString* setIsKey = [[NSString alloc] initWithFormat:@"setIs%@:", Key];
    
    //依次执行上面的三个方法
    BOOL result = [self hq_performSelectorWithMethodName:setKey value:value];
    if(result){
        return ;
    }
    result = [self hq_performSelectorWithMethodName:_setKey value:value];
    if(result){
        return ;
    }
    result = [self hq_performSelectorWithMethodName:setIsKey value:value];
    if(result){
        return ;
    }
    
    //若未找到setter方法，则需要判断 accessInstanceVariablesDirectly 这个值
    result = [self.class accessInstanceVariablesDirectly];
    if(!result){
        @throw [NSException exceptionWithName:@"HQUnknownKeyException" reason:[NSString stringWithFormat:@"****[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key name.****",self] userInfo:nil];
    }
    
    //开始查找成员变量
    NSArray* ivalArr = [self getIvarListName];
    
    //_<key> _is<Key> <key> is<Key>
    NSString* _key = [NSString stringWithFormat:@"_%@", key];
    NSString* _isKey = [NSString stringWithFormat:@"_is%@", Key];
    NSString* isKey = [NSString stringWithFormat:@"is%@", Key];
    if([ivalArr containsObject:_key]){
        Ivar ivar = class_getInstanceVariable(self.class, _key.UTF8String);
        object_setIvar(self, ivar, value);
        return ;
    }
    else if([ivalArr containsObject:_isKey]){
        Ivar ivar = class_getInstanceVariable(self.class, _isKey.UTF8String);
        object_setIvar(self, ivar, value);
        return ;
    }
    else if([ivalArr containsObject:key]){
        Ivar ivar = class_getInstanceVariable(self.class, key.UTF8String);
        object_setIvar(self, ivar, value);
        return ;
    }
    else if([ivalArr containsObject:isKey]){
        Ivar ivar = class_getInstanceVariable(self.class, isKey.UTF8String);
        object_setIvar(self, ivar, value);
        return ;
    }
    
    //如果找不到相关实例，则抛出异常
    @throw [NSException exceptionWithName:@"HQUnknownKeyException" reason:[NSString stringWithFormat:@"****[%@ %@]: this class is not key value coding-compliant for the key name.****",self,NSStringFromSelector(_cmd)] userInfo:nil];
}

- (id)hq_valueForKey:(NSString *)key{
    if (key == nil  || key.length == 0) {
        return nil;
    }
    //查找getter方法 get<Key> --> <key> --> is<Key> --> _<key>
    NSString* Key = [key capitalizedString];
    NSString* getKey = [NSString stringWithFormat:@"get%@", Key];
    NSString* isKey = [NSString stringWithFormat:@"is%@", Key];
    NSString* _key = [NSString stringWithFormat:@"_%@", key];
    
    id value = [self hq_performSelectorWithMethodName:getKey];
    if(value){
        return value;
    }
    value = [self hq_performSelectorWithMethodName:key];
    if (value) {
        return value;
    }
    value = [self hq_performSelectorWithMethodName:isKey];
    if (value) {
        return value;
    }
    value = [self hq_performSelectorWithMethodName:_key];
    if (value) {
        return value;
    }
    
    //查找countOfKey:方法 + objectIn<Key>AtIndex: 或者 <Key>AtIndexes:
    NSString *countOfKey = [NSString stringWithFormat:@"countOf%@",Key];
    NSString *objectInKeyAtIndex = [NSString stringWithFormat:@"objectIn%@AtIndex:",Key];
    NSString *keyAtIndexes = [NSString stringWithFormat:@"%@AtIndexes:", key];
    NSString *enumeratorOfKey = [NSString stringWithFormat:@"enumeratorOf%@",Key];
    NSString *memberOfKey = [NSString stringWithFormat:@"memberOf%@:",Key];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    BOOL result = [self respondsToSelector:NSSelectorFromString(countOfKey)];
    if(result){
        [self performSelector:NSSelectorFromString(countOfKey)];
        if([self respondsToSelector:NSSelectorFromString(objectInKeyAtIndex)]){//countOfKey + objectInKeyAtIndex
            int count = (int)[self performSelector:NSSelectorFromString(countOfKey)];
            NSMutableArray* retArr = [[NSMutableArray alloc] init];
            for (int index = 0; index<count; index++) {
                IMP imp = class_getMethodImplementation(self.class, NSSelectorFromString(objectInKeyAtIndex));
                id (*func)(id, SEL, int) = (void*)imp;
                id obj = func(self, NSSelectorFromString(objectInKeyAtIndex),index);
                [retArr addObject:obj];
            }
            return retArr;
        }
        if([self respondsToSelector:NSSelectorFromString(keyAtIndexes)]){//countOfKey + keyAtIndexes
            int count = (int)[self performSelector:NSSelectorFromString(countOfKey)];
            NSMutableArray* retArr = [[NSMutableArray alloc] init];
            for (int index = 0; index<count; index++) {
                NSIndexSet* indexes = [[NSIndexSet alloc] initWithIndex:index];
                id obj = [self performSelector:NSSelectorFromString(keyAtIndexes) withObject:indexes];
                [retArr addObjectsFromArray:obj];
            }
            return retArr;
        }
        if ([self respondsToSelector:NSSelectorFromString(enumeratorOfKey)] && [self respondsToSelector:NSSelectorFromString(memberOfKey)]) {
            [self performSelector:NSSelectorFromString(countOfKey)];
            id enumerator = [self hq_performSelectorWithMethodName:enumeratorOfKey];
            if(enumerator){
                return [[NSSet alloc] initWithArray:[enumerator allObjects]];
            }
        }
    }
#pragma clang diagnostic pop
    
    //若未找到setter方法，则需要判断 accessInstanceVariablesDirectly 这个值
    result = [self.class accessInstanceVariablesDirectly];
    if(!result){
        @throw [NSException exceptionWithName:@"HQUnknownKeyException" reason:[NSString stringWithFormat:@"****[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key name.****",self] userInfo:nil];
    }
    
    //开始查找成员变量
    NSArray* ivalArr = [self getIvarListName];
    NSLog(@"ivalArr:%@", ivalArr);
    
    // _<Key> --> _is<Key> --> <Key> --> is<Key>
    NSString* _isKey = [NSString stringWithFormat:@"_is%@", Key];
    if([ivalArr containsObject:_key]){
        Ivar ivar = class_getInstanceVariable(self.class, _key.UTF8String);
        return object_getIvar(self, ivar);
    }
    else if([ivalArr containsObject:_isKey]){
        Ivar ivar = class_getInstanceVariable(self.class, _isKey.UTF8String);
        return object_getIvar(self, ivar);
    }
    else if([ivalArr containsObject:key]){
        Ivar ivar = class_getInstanceVariable(self.class, key.UTF8String);
        return object_getIvar(self, ivar);
    }
    else if ([ivalArr containsObject:isKey]){
        Ivar ivar = class_getInstanceVariable(self.class, isKey.UTF8String);
        return object_getIvar(self, ivar);
    }
    
    @throw [NSException exceptionWithName:@"HQUnknownKeyException" reason:[NSString stringWithFormat:@"****[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key name.****",self] userInfo:nil];
    return @"";
}
@end
