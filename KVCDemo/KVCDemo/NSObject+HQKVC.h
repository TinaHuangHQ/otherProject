//
//  NSObject+HQKVC.h
//  KCVDemo
//
//  Created by macbook pro on 2021/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HQKVC)

- (void)hq_setValue:(id)value forKey:(NSString *)key;
- (id)hq_valueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
