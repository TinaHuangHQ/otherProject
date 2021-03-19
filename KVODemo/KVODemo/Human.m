//
//  Human.m
//  KVODemo
//
//  Created by macbook pro on 2021/3/19.
//

#import "Human.h"
#import "NSObject+HQKVO.h"

@implementation Human

- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"注册观察者");
        [self hq_addObserver:self forKeyPath:@"selfName" options:NSKeyValueObservingOptionNew context:nil];
        NSLog(@"注册观察者完成");
    }
    return self;
}

- (void)dealloc{
    NSLog(@"移除观察者");
    [self hq_removeObserver:self forKeyPath:@"selfName" context:nil];
}

- (void)hq_observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    NSLog(@"keyPath:%@", keyPath);
    NSLog(@"object:%@", object);
    NSLog(@"change:%@", change);
    NSLog(@"context:%@", context);
}

@end
