//
//  ViewController.m
//  KVCDemo
//
//  Created by Qiong Huang on 2021/3/17.
//

#import "ViewController.h"
#import "HQPersonSetValue.h"
#import "HQPersonGetValue.h"
#import "KVOOper.h"
#import "NSObject+HQKVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setValue:forKey:
    {
//        HQPersonSetValue* person = [[HQPersonSetValue alloc] init];
//        [person setValue:@"person" forKey:@"name"];
//        NSLog(@"_testName = %@", person->_testName);
//
//        NSLog(@"_name = %@", person->_name);
//        NSLog(@"_isName = %@", person->_isName);
//        NSLog(@"name = %@", person->name);
//        NSLog(@"isName = %@", person->isName);
    }
    
    //valueForKey:
    {
        HQPersonGetValue* person = [[HQPersonGetValue alloc] init];
        id value = [person valueForKey:@"name"];
        NSLog(@"type: %@", NSStringFromClass([value class]));
        NSLog(@"value = %@", value);
    }
    
    //oper
    {
//        KVOOper* oper = [[KVOOper alloc] init];
//        [oper testAvg];
//        [oper testCount];
//        [oper testMax];
//        [oper testMin];
//        [oper testSum];
//        [oper testDistinctUnionOfObjects];
//        [oper testUnionOfObjects];
//        [oper testDistinctUnionOfArrays];
//        [oper testUnionOfArrays];
//        [oper testDistinctUnionOfSets];
    }
    
    //自定义KVC
    {
        HQPersonSetValue* person = [[HQPersonSetValue alloc] init];
//        [person hq_setValue:@"123" forKey:@"name"];
        [person hq_setValue:nil forKey:@"name"];
        NSLog(@"_testName = %@", person->_testName);

        NSLog(@"_name = %@", person->_name);
        NSLog(@"_isName = %@", person->_isName);
        NSLog(@"name = %@", person->name);
        NSLog(@"isName = %@", person->isName);
        
//        HQPersonGetValue* person = [[HQPersonGetValue alloc] init];
//        id value = [person hq_valueForKey:@"name"];
//        NSLog(@"type: %@", NSStringFromClass([value class]));
//        NSLog(@"value = %@", value);
        
    }
    NSLog(@"end");
}


@end

