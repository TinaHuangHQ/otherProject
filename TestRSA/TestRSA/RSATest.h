//
//  RSATest.h
//  TestRSA
//
//  Created by macbook pro on 2020/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSATest : NSObject

+ (NSString*)CryptData:(NSString*)plainText KeyIndex:(int)index Mode:(int)mode;
+ (NSString*)DecryptData:(NSString*)encryptText KeyIndex:(int)index Mode:(int)mode;
@end

NS_ASSUME_NONNULL_END
