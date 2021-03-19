//
//  Department.h
//  KVODemo
//
//  Created by macbook pro on 2021/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Department : NSObject

@property(nonatomic, assign) NSNumber* totalSalary;
- (void)add;
- (void)remove;
- (void)replace;

@end

NS_ASSUME_NONNULL_END
