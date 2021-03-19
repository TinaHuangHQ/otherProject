//
//  Employee.m
//  KVODemo
//
//  Created by macbook pro on 2021/3/19.
//

#import "Employee.h"

@implementation Employee

- (instancetype) initWithSalary:(NSNumber*)salary {
    self = [super init];
    if (self) {
        self.salary = salary;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"class:%@, salary:%@", [super description], self.salary];
}

@end
