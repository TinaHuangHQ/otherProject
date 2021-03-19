//
//  Employee.h
//  KVODemo
//
//  Created by macbook pro on 2021/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Employee : NSObject

@property(nonatomic, assign) NSNumber* salary;

- (instancetype) initWithSalary:(NSNumber*)salary;

@end

NS_ASSUME_NONNULL_END
