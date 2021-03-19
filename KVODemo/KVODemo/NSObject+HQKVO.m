//
//  NSObject+HQKVO.m
//  KVODemo
//
//  Created by macbook pro on 2021/3/19.
//

#import "NSObject+HQKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "HQKVOInfo.h"
#import <Foundation/NSKeyValueObserving.h>

static NSString *const kLGKVOAssiociateKey = @"kLGKVO_AssiociateKey";

typedef NS_OPTIONS(NSUInteger, HQKeyValueObservingOptions) {
    HQKeyValueObservingOptionNew = 0x01,
    HQKeyValueObservingOptionOld = 0x02,
    HQKeyValueObservingOptionInitial = 0x04,
    HQKeyValueObservingOptionPrior = 0x08

};

static NSString *getterForSetter(NSString *setter){
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}

static NSString *setterForGetter(NSString *getter){
    if (getter.length <= 0) { return nil;}
    NSString *firstString = [[getter substringToIndex:1] uppercaseString];
    NSString *leaveString = [getter substringFromIndex:1];
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}

static void hq_setter(id self,SEL _cmd,id newValue){
    //1. 消息转发 : 转发给父类
    NSString* keyPath = getterForSetter(NSStringFromSelector(_cmd));
    void (*hq_msgSendSuper)(void *,SEL , id) = (void *)objc_msgSendSuper;
    struct objc_super superStruct = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self)),
    };
    hq_msgSendSuper(&superStruct, _cmd, newValue);
    
    //2: 拿到观察者
    id oldValue = [self valueForKey:keyPath];
    NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
    for (HQKVOInfo* info in observerArr) {
        if ([info.keyPath isEqualToString:keyPath]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //创建一个字典，这里仅模拟设值的情况 NSKeyValueChangeKey = NSKeyValueChangeSetting
                NSMutableDictionary<NSKeyValueChangeKey,id> *change = [NSMutableDictionary dictionaryWithCapacity:1];
                [change setObject:@1 forKey:NSKeyValueChangeKindKey];
                // 对新旧值进行处理
                if (info.options & HQKeyValueObservingOptionNew) {
                    [change setObject:newValue forKey:NSKeyValueChangeNewKey];
                }
                if (info.options & HQKeyValueObservingOptionOld) {
                    [change setObject:@"" forKey:NSKeyValueChangeOldKey];
                    if (oldValue) {
                        [change setObject:oldValue forKey:NSKeyValueChangeOldKey];
                    }
                }
                // 2: 消息发送给观察者
                SEL observerSEL = @selector(hq_observeValueForKeyPath:ofObject:change:context:);
                objc_msgSend(info.observer,observerSEL,keyPath,self,change,info.context);
            });
        }
    }
}

//3.获取当前类的父类
Class hq_class(id self, SEL _cmd){
    return class_getSuperclass(object_getClass(self));
}

//4. 重写dealloc方法
void hq_dealloc(id self, SEL _cmd){
    NSLog(@"移除观察者");
    Class superClass = [self class];
    object_setClass(self, superClass);
}

@implementation NSObject (HQKVO)

- (void)hq_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context{
    //1.判断对象属性是否有Setter方法，若没有的话，则不允许继续执行KVO
    [self judgeSetterMethodFromKeyPath:keyPath];
    //2. 动态生成子类
    Class newClass = [self createChildClassWithKeyPath:keyPath];
    
    //3. 修改实例对象的isa，使它指向新生成的类
    object_setClass(self, newClass);
    
    //4. 保存当前观察者信息
    HQKVOInfo* kvoInfo = [[HQKVOInfo alloc] initWithObserver:observer forKeyPath:keyPath options:options context:context];
    NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
    if (!observerArr) {
        observerArr = [NSMutableArray arrayWithCapacity:1];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey), observerArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observerArr addObject:kvoInfo];
}

- (void)hq_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
}

- (void)hq_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context{
    //1.查看关联对象数组是否存在，不存在则表示当前不需要移除观察者
    NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
    if (observerArr.count<=0) {
        return;
    }
    
    //遍历关联对象数组，找到当前需要移除的观察者，将其从关联对象的数组中移除
    for (HQKVOInfo *info in observerArr) {
        if ([info.keyPath isEqualToString:keyPath]) {
            [observerArr removeObject:info];
            objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey), observerArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        }
    }
    
    //当关联对象的数组为空时，表示当前没有观察者，因此，需要将实例对象的isa指回原来的类，原来的类也是新建类的父类
    if (observerArr.count<=0) {
        Class superClass = [self class];
        object_setClass(self, superClass);
    }
}

//1.判断当前属性是否有setter方法
- (void)judgeSetterMethodFromKeyPath:(NSString *)keyPath {
    Method setterMethod = class_getInstanceMethod(object_getClass(self), NSSelectorFromString(setterForGetter(keyPath)));
    if(!setterMethod){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"属性%@没有setter方法",keyPath] userInfo:nil];
    }
}

//2.创建当前类的子类 NSKVONotifying_xxx
- (Class)createChildClassWithKeyPath:(NSString*)keyPath{
    //获取当前类的类名
    NSString* oldClassName = NSStringFromClass([self class]);
    //拼接当前类名为 NSKVONotifying_xxx
    NSString* newClassName = [NSString stringWithFormat:@"HQKVONotifying_%@", oldClassName];
    //根据名称生成一个类指针
    Class newClass = NSClassFromString(newClassName);
    
    //如果子类存在，则直接返回，因为 NSKVONotifying_xxx 类可能已经被注册到内存了
    if (newClass) return newClass;
    //创建类，完善类结构，如isa，supperclass等
    newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    //创建完成的类需要完成注册
    objc_registerClassPair(newClass);
    
    //添加class方法
    SEL classSel = @selector(class);
    Method classMethod = class_getInstanceMethod([self class], classSel);
    const char *classType = method_getTypeEncoding(classMethod);
    //SEL:class IMP:hq_class
    class_addMethod(newClass, classSel, (IMP)hq_class, classType);
    
    //重写属性的setter方法
    SEL setter = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setter);
    const char* setterType = method_getTypeEncoding(setterMethod);
    class_addMethod(newClass, setter, (IMP)hq_setter, setterType);
    
    //重写delloc方法
    SEL dellocSetter = NSSelectorFromString(@"dealloc");
    Method dellocMethod = class_getInstanceMethod([self class], dellocSetter);
    const char* dellocType = method_getTypeEncoding(dellocMethod);
    class_addMethod(newClass, dellocSetter, (IMP)hq_dealloc, dellocType);
    
    return newClass;
}


@end
