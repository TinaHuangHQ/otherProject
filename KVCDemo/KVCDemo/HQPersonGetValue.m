//
//  HQPersonGetValue.m
//  KCVDemo
//
//  Created by macbook pro on 2021/3/17.
//

#import "HQPersonGetValue.h"

@interface HQPersonGetValue ()
{
    NSString* _name;
    NSString* _isName;
    NSString* name;
    NSString* isName;
}
@end

/*
 这个类用于演示 valueForKey: 函数的查找流程
 1：查找是否存在getter方法，查找流程：
    get<Key> --> <Key> --> is<Key> --> _<Key>
 2: 若getter方法未找到，此时针对集合类型做了一些特殊处理。查找是否存在 countOf<Key> 方法
    2.1 若存在 countOf<Key> 方法，
        2.1.1 查找是否存在 objectIn<Key>AtIndex: 或者 <Key>AtIndexes:
            2.1.1.1 若存在，则执行 objectIn<Key>AtIndex: 或 <Key>AtIndexes:
            2.1.1.2 若不存在，则进入2.1.2
        2.1.2 查找是否存在 enumeratorOf<Key>: 并且存在 memberOf<Key>:
            2.1.2.1 若存在，则执行 enumeratorOf<Key>: 和 memberOf<Key>:
            2.1.2.2 若不存在，则进入步骤3
    2.2 若不存在 countOf<Key> 方法，则进入步骤3
 3：检查accessInstanceVariablesDirectly这个布尔值
    若为YES，则查找成员变量，查找流程：
        _<Key> --> _is<Key> --> <Key> --> is<Key>
    若为NO，则直接进入步骤4
 4：若是以上都查找失败，则执行 valueForUndefinedKey: 方法，应用可重写该方法
 */
@implementation HQPersonGetValue

- (instancetype)init {
    self = [super init];
    if (self) {
        self.arr = @[@"11", @"22", @"33", @"44"];
        self.set = [[NSSet alloc] initWithArray:@[@1, @2, @3]];
        _name = @"_name";
        _isName = @"_isName";
        name = @"name";
        isName = @"isName";
    }
    return self;
}

// 个数
- (NSUInteger)countOfName{
    NSLog(@"%s",__func__);
    return [self.arr count];
//    return [self.set count];
}

// 获取值
- (id)objectInNameAtIndex:(NSUInteger)index {
    NSLog(@"%s---%lu",__func__, (unsigned long)index);
    return self.arr[index];
}

- (NSArray *)nameAtIndexes:(NSIndexSet *)indexes{
    NSLog(@"%s, %@",__func__, indexes);
    __block NSMutableArray* returnArr = [[NSMutableArray alloc] init];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%lu", (unsigned long)idx);
        [returnArr addObject:self.arr[idx]];
    }];
    return returnArr;
}
//
//- (id)enumeratorOfName {
//    NSLog(@"%s", __func__);
//    return [self.set objectEnumerator];
//}
//
//- (id)memberOfName:(id)object {
//    NSLog(@"%s",__func__);
//    return [self.set containsObject:object] ? object : nil;
//}

@end
