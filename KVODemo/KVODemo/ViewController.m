//
//  ViewController.m
//  KVODemo
//
//  Created by macbook pro on 2021/3/18.
//

#import "ViewController.h"
#import "Person.h"
#import "Department.h"
#import "PersonSwizzling.h"
#import "Human.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //KVO基本使用
#if 0
    {
        Person* person = [[Person alloc] init];
        //向观察的属性直接赋值，可触发回调
        person.name = @"123";
        //通过KVO向观察的属性直接赋值，可触发回调
        [person setValue:@"456" forKey:@"name"];
        //通过KVO向观察的属性赋值，可触发回调
        //NSKeyValueChangeKindKey = NSKeyValueChangeSetting
        NSArray* arr = [@[@11, @22, @33] mutableCopy];
        [person setValue:arr forKey:@"arr"];
        
        //可变数组直接添加值，不会触发观察者回调
        [person.arr addObject:@10];
        
        //官方描述需要通过 mutableArrayValueForKey 方法先获取值，再对可变数组进行操作，才能触发回调
        //此时NSKeyValueChangeKindKey = NSKeyValueChangeInsertion
        [[person mutableArrayValueForKey:@"arr"] addObject:@10];
        //此时NSKeyValueChangeKindKey = NSKeyValueChangeRemoval
        [[person mutableArrayValueForKey:@"arr"] removeObject:@11];
        //此时NSKeyValueChangeKindKey = NSKeyValueChangeReplacement
        [[person mutableArrayValueForKey:@"arr"] replaceObjectAtIndex:0 withObject:@30];
        
    }
#endif
    
    //依赖属性KVO
    {
//        Person* person = [Person new];
//        person.firstName = @"hello";
//        person.lastName = @"world";
//        NSLog(@"full name:%@",person.fullName);
//        [person setFirstName:@"hi"];
//        NSLog(@"full name:%@",person.fullName);
//        [person setLastName:@"human"];
//        NSLog(@"full name:%@",person.fullName);
    }
    
    //依赖属性KVO
    {
//        Department* department = [[Department alloc] init];
//        NSLog(@"total = %@",department.totalSalary);
//        [department add];
//        NSLog(@"total = %@",department.totalSalary);
//        [department remove];
//        NSLog(@"total = %@",department.totalSalary);
//        [department replace];
//        NSLog(@"total = %@",department.totalSalary);
    }
    
    //自定义KVO
    {
        Human* person = [[Human alloc] init];
        person.selfName = @"123";
    }
}


@end
