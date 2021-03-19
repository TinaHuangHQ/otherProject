//
//  Person.m
//  KVODemo
//
//  Created by macbook pro on 2021/3/18.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person


- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"注册观察者");
        self.arr = [@[@1, @2, @3, @4, @5] mutableCopy];
        [self addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
        [self addObserver:self forKeyPath:@"arr" options:(NSKeyValueObservingOptionNew) context:@"ToMany"];
        NSLog(@"注册观察者完成");
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"keyPath:%@", keyPath);
    NSLog(@"object:%@", object);
    NSLog(@"change:%@", change);
    NSLog(@"context:%@", context);
}

- (NSString *)fullName{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

//+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
//    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
//
//    if ([key isEqualToString:@"fullName"]) {
//        NSArray *affectingKeys = @[@"lastName", @"firstName"];
//        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
//    }
//    return keyPaths;
//}

//+ (NSSet *)keyPathsForValuesAffectingFullName {
//    return [NSSet setWithObjects:@"lastName", @"firstName", nil];
//}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"fullName"]) {
        keyPaths = [NSSet setWithObjects:@"lastName", @"firstName", nil];
    }
    return keyPaths;
}

//当automaticallyNotifiesObserversForKey 为NO 时，自动触发KVO
- (void)setName:(NSString *)name{
    [self willChangeValueForKey:@"name"];
    _name = name;
    [self didChangeValueForKey:@"name"];
}

//返回YES：自动触发KVO
//返回NO：不会自动触发KVO
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
    BOOL automatic = NO;
    if ([key isEqualToString:@"name"]) {
        automatic = NO;
    }
    else {
        automatic = [super automaticallyNotifiesObserversForKey:key];
    }
    return automatic;
}

- (void)dealloc{
    NSLog(@"移除观察者");
    [self removeObserver:self forKeyPath:@"name" context:nil];
    [self removeObserver:self forKeyPath:@"arr" context:@"ToMany"];
}

@end
