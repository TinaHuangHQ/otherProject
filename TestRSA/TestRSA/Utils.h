//
//  Utils.h
//  TestRSA
//
//  Created by macbook pro on 2020/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+ (NSData *) getBcdFromString:(NSString *)string;
+ (NSString *) getStringFromBcd:(NSData *)bcd;

@end

NS_ASSUME_NONNULL_END
