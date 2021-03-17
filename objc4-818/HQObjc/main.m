//
//  main.m
//  HQObjc
//
//  Created by Qiong Huang on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import "HQPerson.h"
#import "HQPerson+HQA.h"
#import "runtime.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        // 0x00007ffffffffff8ULL
        HQPerson* person = [HQPerson alloc];
        person.cateName = @"123";
        NSLog(@"%@",person.cateName);
        
        NSLog(@"%@", person);
    }
    return 0;
}
