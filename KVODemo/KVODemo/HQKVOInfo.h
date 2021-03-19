//
//  HQKVOInfo.h
//  KVODemo
//
//  Created by macbook pro on 2021/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQKVOInfo : NSObject
@property(nonatomic, weak) NSObject *observer;
@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, assign) NSUInteger options;
@property(nonatomic, assign) void *context;

- (instancetype)initWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
@end

NS_ASSUME_NONNULL_END
