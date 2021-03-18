//
//  Person.h
//  KVODemo
//
//  Created by macbook pro on 2021/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSMutableArray* arr;
@property(nonatomic, strong) NSString* firstName;
@property(nonatomic, strong) NSString* lastName;
@property(nonatomic, strong) NSString* fullName;

@end

NS_ASSUME_NONNULL_END
