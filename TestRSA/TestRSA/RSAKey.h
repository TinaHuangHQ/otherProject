//
//  RSAKey.h
//  TestRSA
//
//  Created by macbook pro on 2020/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSAKey : NSObject

@property(nonatomic, strong) NSData *modulusData;
@property(nonatomic, strong) NSData *exponent_pub;
@property(nonatomic, strong) NSData *exponent_pri;

@end

NS_ASSUME_NONNULL_END
