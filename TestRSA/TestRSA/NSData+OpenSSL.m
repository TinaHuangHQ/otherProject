//
//  NSData+OpenSSL.m
//  QuickRSA
//
//  Created by liuyuning on 2016/10/19.
//  Copyright © 2016年 liuyuning. All rights reserved.
//

#import "NSData+OpenSSL.h"
#import <openssl/pem.h>

@implementation NSData(OpenSSL)
- (NSData *)OpenSSL_RSA_DataEncryptWithKey:(RSA *)rsaKey isPublic:(BOOL)isPublic{
    NSMutableData *cipherData = [NSMutableData data];
    int padding = RSA_NO_PADDING;
    
    if (rsaKey) {
        int size = RSA_size(rsaKey);
        NSData *plainData = self;
        char* pText = calloc(size, 0);
        memcpy(pText, plainData.bytes, plainData.length);
        uint8_t *buffer = malloc(size);
        if (buffer) {
            
            NSUInteger offset = 0;
            NSUInteger length = 0;
            
            do {
                length = plainData.length - offset;
                if(padding == RSA_NO_PADDING){
                    length = size;
                }
                else{
                    if (length > size - 11) {
                        length = size - 11;
                    }
                }
                
                int out_len = 0;
                if (isPublic) {
                    out_len = RSA_public_encrypt((int)length, (uint8_t *)pText + offset, buffer, rsaKey, padding);
                }
                else{
                    out_len = RSA_private_encrypt((int)length, (uint8_t *)pText + offset, buffer, rsaKey, padding);
                }
                
                if (out_len > 0) {
                    [cipherData appendBytes:buffer length:out_len];
                }
                else{
                    NSLog(@"RSA_public_encrypt error:%d",out_len);
                    cipherData = nil;
                    break;
                }
                offset += length;
            } while (offset < self.length);
            free(buffer);
        }
    }
    return cipherData.length ? cipherData : nil;
}

- (NSData *)OpenSSL_RSA_DataDecryptWithKey:(RSA *)rsaKey isPublic:(BOOL)isPublic{
    NSMutableData *plainData = [NSMutableData data];
    NSData *cipherData = self;
    if (rsaKey) {
        int block_size = RSA_size(rsaKey);
        uint8_t *buffer = malloc(block_size);
        
        if (buffer) {
            for (int i = 0; i < cipherData.length / block_size; i++) {
                
                int out_len = 0;
                if (isPublic) {
                    out_len = RSA_public_decrypt(block_size, (uint8_t *)self.bytes + block_size * i, buffer, rsaKey, RSA_NO_PADDING);
                }
                else{
                    out_len = RSA_private_decrypt(block_size, (uint8_t *)self.bytes + block_size * i, buffer, rsaKey, RSA_NO_PADDING);
                }
                
                if (out_len > 0) {
                    [plainData appendBytes:buffer length:strlen((const char *)buffer)];
                }
                else{
                    NSLog(@"RSA_private_decrypt error:%d",out_len);
                    plainData = nil;
                    break;
                }
            }
            free(buffer);
        }
    }
    return plainData.length ? plainData : nil;
}

//Use PEM format, Pub(Pri) Enc -> Pri(Pub) Dec
- (NSData *)OpenSSL_RSA_EncryptDataWithPEM:(NSData *)pemData isPublic:(BOOL)isPublic{
    NSData *outData = nil;
    RSA *rsa = NULL;
    
    BIO *bio = BIO_new_mem_buf((uint8_t *)pemData.bytes, (int)pemData.length);
    if (bio) {
        rsa = isPublic ? PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL) : PEM_read_bio_RSAPrivateKey(bio, NULL, NULL, NULL);
        BIO_free(bio);
    }
    
    if (rsa) {
        outData = [self OpenSSL_RSA_DataEncryptWithKey:rsa isPublic:isPublic];
        RSA_free(rsa);
    }
    return outData;
}
//Use PEM format, Pub(Pri) Enc -> Pri(Pub) Dec
- (NSData *)OpenSSL_RSA_DecryptDataWithPEM:(NSData *)pemData isPublic:(BOOL)isPublic{
    NSData *outData = nil;
    RSA *rsa = NULL;
    
    BIO *bio = BIO_new_mem_buf((uint8_t *)pemData.bytes, (int)pemData.length);
    if (bio) {
        rsa = isPublic ? PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL) : PEM_read_bio_RSAPrivateKey(bio, NULL, NULL, NULL);
        BIO_free(bio);
    }
    
    if (rsa) {
        outData = [self OpenSSL_RSA_DataDecryptWithKey:rsa isPublic:isPublic];
        RSA_free(rsa);
    }
    return outData;
}

//Use DER format, Pub(Pri) Enc -> Pri(Pub) Dec
- (NSData *)OpenSSL_RSA_EncryptDataWithDER:(NSData *)derData isPublic:(BOOL)isPublic{
    
    if (!derData) {
        return nil;
    }
    NSData *outData = nil;
    const unsigned char *pp = derData.bytes;
    
    RSA *rsa = isPublic ? d2i_RSA_PUBKEY(NULL, &pp, derData.length) : d2i_RSAPrivateKey(NULL, &pp, derData.length);
    if (rsa) {
        outData = [self OpenSSL_RSA_DataEncryptWithKey:rsa isPublic:isPublic];
        RSA_free(rsa);
    }
    return outData;
}

//Use DER format, Pub(Pri) Enc -> Pri(Pub) Dec
- (NSData *)OpenSSL_RSA_DecryptDataWithDER:(NSData *)derData isPublic:(BOOL)isPublic{
    
    if (!derData) {
        return nil;
    }
    NSData *outData = nil;
    const unsigned char *pp = derData.bytes;
    RSA *rsa = isPublic ? d2i_RSA_PUBKEY(NULL, &pp, derData.length) : d2i_RSAPrivateKey(NULL, &pp, derData.length);
    if (rsa) {
        outData = [self OpenSSL_RSA_DataDecryptWithKey:rsa isPublic:isPublic];
        RSA_free(rsa);
    }
    return outData;
}

//Use modulus and exponent
- (NSData *)OpenSSL_RSA_Encrypt_DataWithPublicModulus:(NSData *)modulus exponent:(NSData *)exponent{
    if (!modulus || !exponent) {
        return nil;
    }
    
    NSData *outData = nil;
    RSA *rsa = RSA_new();
    BIGNUM *n = NULL;
    BIGNUM *e = NULL;
    if (rsa) {
        n = BN_bin2bn(modulus.bytes, (int)modulus.length, NULL);
        e = BN_bin2bn(exponent.bytes, (int)exponent.length, NULL);
        RSA_set0_key(rsa, n, e, NULL);
        if (e && n) {
            outData = [self OpenSSL_RSA_DataEncryptWithKey:rsa isPublic:YES];
        }
        RSA_free(rsa);
    }
    return outData;
}

//Use modulus and exponent
- (NSData *)OpenSSL_RSA_Decrypt_DataWithPublicModulus:(NSData *)modulus exponent:(NSData *)exponent{
    if (!modulus || !exponent) {
        return nil;
    }
    
    NSData *outData = nil;
    RSA *rsa = RSA_new();
    BIGNUM *n = NULL;
    BIGNUM *e = NULL;
    if (rsa) {
        n = BN_bin2bn(modulus.bytes, (int)modulus.length, NULL);
        e = BN_bin2bn(exponent.bytes, (int)exponent.length, NULL);
        RSA_set0_key(rsa, n, e, NULL);
        if (e && n) {
            outData = [self OpenSSL_RSA_DataDecryptWithKey:rsa isPublic:YES];
        }
        RSA_free(rsa);
    }
    return outData;
}

//Use modulus and exponent
- (NSData *)OpenSSL_RSA_DataWithPublicModulus:(NSData *)modulus exponent:(NSData *)exponent isDecrypt:(BOOL)isDecrypt{
    
    if (!modulus || !exponent) {
        return nil;
    }
    
    NSData *outData = nil;
    RSA *rsa = RSA_new();
    BIGNUM *n = NULL;
    BIGNUM *e = NULL;
    if (rsa) {
        n = BN_bin2bn(modulus.bytes, (int)modulus.length, NULL);
        e = BN_bin2bn(exponent.bytes, (int)exponent.length, NULL);
        RSA_set0_key(rsa, n, e, NULL);
        if (e && n) {
            if (isDecrypt) {
                //公钥解密 -- 私钥加密
//                outData = [self OpenSSL_RSA_DataDecryptWithKey:rsa isPublic:YES];
                //私钥解密 -- 公钥加密
                outData = [self OpenSSL_RSA_DataDecryptWithKey:rsa isPublic:YES];
            }
            else{
                //私钥加密 -- 公钥解密
//                outData = [self OpenSSL_RSA_DataEncryptWithKey:rsa isPublic:NO];
                //公钥加密 -- 私钥解密
                outData = [self OpenSSL_RSA_DataEncryptWithKey:rsa isPublic:YES];
            }
        }
        RSA_free(rsa);
    }
    return outData;
}

//Use modulus and exponent
- (NSData *)OpenSSL_RSA_Encrypt_DataWithPrivateModulus:(NSData *)modulus pubExponent:(NSData *)pubExponent priExponent:(NSData *)priExponent{
    if (!modulus || !pubExponent) {
        return nil;
    }
    
    NSData *outData = nil;
    RSA *rsa = RSA_new();
    BIGNUM *n = NULL;
    BIGNUM *e = NULL;
    BIGNUM *d = NULL;
    if (rsa) {
        n = BN_bin2bn(modulus.bytes, (int)modulus.length, NULL);
        e = BN_bin2bn(pubExponent.bytes, (int)pubExponent.length, NULL);
        d = BN_bin2bn(priExponent.bytes, (int)priExponent.length, NULL);
        RSA_set0_key(rsa, n, e, d);
        if (e && n) {
//            私钥加密 -- 公钥解密
            outData = [self OpenSSL_RSA_DataEncryptWithKey:rsa isPublic:NO];
        }
        RSA_free(rsa);
    }
    return outData;
}

//Use modulus and exponent
- (NSData *)OpenSSL_RSA_Decrypt_DataWithPrivateModulus:(NSData *)modulus pubExponent:(NSData *)pubExponent priExponent:(NSData *)priExponent{
    if (!modulus || !pubExponent) {
        return nil;
    }
    
    NSData *outData = nil;
    RSA *rsa = RSA_new();
    BIGNUM *n = NULL;
    BIGNUM *e = NULL;
    BIGNUM *d = NULL;
    if (rsa) {
        n = BN_bin2bn(modulus.bytes, (int)modulus.length, NULL);
        e = BN_bin2bn(pubExponent.bytes, (int)pubExponent.length, NULL);
        d = BN_bin2bn(priExponent.bytes, (int)priExponent.length, NULL);
        RSA_set0_key(rsa, n, e, d);
        if (e && n) {
//            私钥解密 -- 公钥加密
            outData = [self OpenSSL_RSA_DataDecryptWithKey:rsa isPublic:NO];
        }
        RSA_free(rsa);
    }
    return outData;
}

//Use modulus and exponent
- (NSData *)OpenSSL_RSA_DataWithPublicModulus:(NSData *)modulus pubExponent:(NSData *)pubExponent priExponent:(NSData *)priExponent isDecrypt:(BOOL)isDecrypt mode:(int)mode{
    
    if (!modulus || !pubExponent) {
        return nil;
    }
    
    NSData *outData = nil;
    RSA *rsa = RSA_new();
    BIGNUM *n = NULL;
    BIGNUM *e = NULL;
    BIGNUM *d = NULL;
    if (rsa) {
        n = BN_bin2bn(modulus.bytes, (int)modulus.length, NULL);
        e = BN_bin2bn(pubExponent.bytes, (int)pubExponent.length, NULL);
        d = BN_bin2bn(priExponent.bytes, (int)priExponent.length, NULL);
        RSA_set0_key(rsa, n, e, d);
        if (e && n) {
            if (isDecrypt) {
                if(mode == 0){
//                    私钥解密 -- 公钥加密
                    outData = [self OpenSSL_RSA_DataDecryptWithKey:rsa isPublic:NO];
                }
                else{
//                    公钥解密 -- 私钥加密
                    outData = [self OpenSSL_RSA_DataDecryptWithKey:rsa isPublic:YES];
                }
            }
            else{
                if(mode == 0){
//                    公钥加密 -- 私钥解密
                    outData = [self OpenSSL_RSA_DataEncryptWithKey:rsa isPublic:YES];
                }
                else{
//                    私钥加密 -- 公钥解密
                    outData = [self OpenSSL_RSA_DataEncryptWithKey:rsa isPublic:NO];
                }
            }
        }
        RSA_free(rsa);
    }
    return outData;
}

@end

