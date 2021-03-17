//
//  HQPerson+HQA.m
//  HQObjc
//
//  Created by Qiong Huang on 2021/2/27.
//

#import "HQPerson+HQA.h"
#import "runtime.h"

@implementation HQPerson (HQA)

- (void)setCateName:(NSString *)cateName{
    objc_setAssociatedObject(self, "cateName", cateName, 3);
}

- (NSString *)cateName{
    return objc_getAssociatedObject(self, "cateName");
}

@end
