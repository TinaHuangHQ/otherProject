//
//  Department.m
//  KVODemo
//
//  Created by macbook pro on 2021/3/19.
//

#import "Department.h"
#import "Employee.h"

@interface Department ()

@property(nonatomic, strong) NSMutableArray* employees;

@end

@implementation Department

- (instancetype)init {
    self = [super init];
    if (self) {
        Employee* e1 = [[Employee alloc] initWithSalary:@10];
        Employee* e2 = [[Employee alloc] initWithSalary:@20];
        Employee* e3 = [[Employee alloc] initWithSalary:@30];
        self.employees = [@[e1, e2, e3] mutableCopy];
        self.totalSalary = [self valueForKeyPath:@"employees.@sum.salary"];
        [self addObserver:self forKeyPath:@"employees" options:NSKeyValueObservingOptionNew context:@"totalSalaryContext"];
    }
    return self;
}

- (void)add {
    Employee* e = [[Employee alloc] initWithSalary:@11];
    [[self mutableArrayValueForKey:@"employees"] addObject:e];
}

- (void)remove {
    Employee* e = [self.employees objectAtIndex:1];
    [[self mutableArrayValueForKey:@"employees"] removeObject:e];
}

- (void)replace{
    Employee* e = [[Employee alloc] initWithSalary:@22];
    [[self mutableArrayValueForKey:@"employees"] replaceObjectAtIndex:2 withObject:e];
}

- (void)updateTotalSalary {
    [self setTotalSalary:[self valueForKeyPath:@"employees.@sum.salary"]];
}

- (void)setTotalSalary:(NSNumber *)newTotalSalary {
    if (_totalSalary != newTotalSalary) {
        [self willChangeValueForKey:@"totalSalary"];
        _totalSalary = newTotalSalary;
        [self didChangeValueForKey:@"totalSalary"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@", change);
    if (context == @"totalSalaryContext") {
        [self updateTotalSalary];
    }
}

@end
