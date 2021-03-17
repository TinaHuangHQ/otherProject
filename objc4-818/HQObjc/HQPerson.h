//
//  HQPerson.h
//  HQObjc
//
//  Created by Qiong Huang on 2021/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQPerson : NSObject

@property(nonatomic, copy)NSString* propertyParam;

- (void)doSomething;
- (void)saySomething;

@end

NS_ASSUME_NONNULL_END
