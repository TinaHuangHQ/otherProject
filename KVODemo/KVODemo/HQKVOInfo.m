//
//  HQKVOInfo.m
//  KVODemo
//
//  Created by macbook pro on 2021/3/19.
//

#import "HQKVOInfo.h"

@implementation HQKVOInfo

- (instancetype)initWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    self = [super init];
    if (self) {
        self.observer = observer;
        self.keyPath = keyPath;
        self.options = options;
        self.context = context;
    }
    return self;
}

@end
