//
//  HQPersonSetValue.m
//  KCVDemo
//
//  Created by macbook pro on 2021/3/17.
//

#import "HQPersonSetValue.h"
/*
 这个类用于演示 setValue:forKey: 函数的查找流程
 1：查找是否存在setter方法，查找流程：
    set<Key> --> _set<Key> --> setIs<Key>
 2：若setter方法未找到，检查accessInstanceVariablesDirectly这个布尔值
    若为YES，则查找成员变量
        查找顺序：_<Key>` --> _is<Key> --> <Key> --> is<Key>
    若为NO，则直接进入步骤3
 3：若是setter方法和成员变量均未找到，执行setValue:forUndefinedKey:方法，应用可重写该方法
 */
@implementation HQPersonSetValue
//- (void)setName:(NSString*)name{
//    NSLog(@"%s",__func__);
//    _testName = name;
//}

//- (void)_setName:(NSString*)name{
//    NSLog(@"%s",__func__);
//    _testName = name;
//}

//- (void)setIsName:(NSString*)name{
//    NSLog(@"%s",__func__);
//    _testName = name;
//}

//不会调用
- (void)_setIsName:(NSString *)name{
    NSLog(@"%s - %@",__func__,name);
    _testName = name;
}

+ (BOOL)accessInstanceVariablesDirectly{
    return YES;
}

@end
