//
//  PersonSwizzling.m
//  KVODemo
//
//  Created by macbook pro on 2021/3/19.
//

#import "PersonSwizzling.h"
#import <objc/runtime.h>

@implementation PersonSwizzling

#pragma mark - 遍历类以及子类
- (void)printClasses:(Class)cls{
    // 注册类的总数
    int count = objc_getClassList(NULL, 0);
    // 创建一个数组， 其中包含给定对象
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:cls];
    // 获取所有已注册的类
    Class* classes = (Class*)malloc(sizeof(Class)*count);
    objc_getClassList(classes, count);
    for (int i = 0; i<count; i++) {
        if (cls == class_getSuperclass(classes[i])) {
            [mArray addObject:classes[i]];
        }
    }
    free(classes);
    NSLog(@"classes = %@", mArray);
}

- (void)printClassAllMethod:(Class)cls{
    unsigned int outCount = 0;
    Method* methodList = class_copyMethodList(cls, &outCount);
    for(int i = 0; i<outCount; i++){
        Method method = methodList[i];
        SEL sel = method_getName(method);
        IMP imp = method_getImplementation(method);
        NSLog(@"sel:%@, imp:%p", NSStringFromSelector(sel), imp);
    }
    free(methodList);
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"注册观察者");
        [self addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
        NSLog(@"注册观察者完成");
        [self printClassAllMethod:objc_getClass("NSKVONotifying_PersonSwizzling")];
    }
    return self;
}

@end
