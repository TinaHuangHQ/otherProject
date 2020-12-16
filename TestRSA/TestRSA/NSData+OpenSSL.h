//
//  NSData+OpenSSL.h
//  QuickRSA
//
//  Created by liuyuning on 2016/10/19.
//  Copyright © 2016年 liuyuning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(OpenSSL)

//Use PEM format, Pub(Pri) Enc -> Pri(Pub) Dec
- (NSData *)OpenSSL_RSA_EncryptDataWithPEM:(NSData *)pemData isPublic:(BOOL)isPublic;//PEM key
- (NSData *)OpenSSL_RSA_DecryptDataWithPEM:(NSData *)pemData isPublic:(BOOL)isPublic;//PEM key

//Use DER format, Pub(Pri) Enc -> Pri(Pub) Dec
- (NSData *)OpenSSL_RSA_EncryptDataWithDER:(NSData *)derData isPublic:(BOOL)isPublic;//DER key
- (NSData *)OpenSSL_RSA_DecryptDataWithDER:(NSData *)derData isPublic:(BOOL)isPublic;//DER key

- (NSData *)OpenSSL_RSA_Encrypt_DataWithPublicModulus:(NSData *)modulus exponent:(NSData *)exponent;
- (NSData *)OpenSSL_RSA_Decrypt_DataWithPublicModulus:(NSData *)modulus exponent:(NSData *)exponent;

- (NSData *)OpenSSL_RSA_Encrypt_DataWithPrivateModulus:(NSData *)modulus pubExponent:(NSData *)pubExponent priExponent:(NSData *)priExponent;
- (NSData *)OpenSSL_RSA_Decrypt_DataWithPrivateModulus:(NSData *)modulus pubExponent:(NSData *)pubExponent priExponent:(NSData *)priExponent;
@end
