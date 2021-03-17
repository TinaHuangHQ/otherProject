//
//  HQPerson.m
//  HQObjc
//
//  Created by Qiong Huang on 2021/1/20.
//

#import "HQPerson.h"
#import "runtime.h"

@implementation HQPerson

+ (void)load{
    NSLog(@"%s", __func__);
}

- (void)doSomething{
    NSLog(@"%s", __func__);
}

- (void)saySomething{
    NSLog(@"%s", __func__);
}

@end
