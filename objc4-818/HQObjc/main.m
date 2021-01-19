//
//  main.m
//  HQObjc
//
//  Created by Qiong Huang on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import "HQPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        HQPerson* person = [HQPerson alloc];
        NSLog(@"%@", person);
    }
    return 0;
}
