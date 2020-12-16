//
//  RSATest.m
//  TestRSA
//
//  Created by macbook pro on 2020/12/16.
//

#import "RSATest.h"
#import "Utils.h"
#import "RSAKey.h"
#import "NSData+OpenSSL.h"

@interface RSATest ()

@end


@implementation RSATest
+ (RSAKey*)getKey1{
    static unsigned char n[] =
            "\x00\xBB\xF8\x2F\x09\x06\x82\xCE\x9C\x23\x38\xAC\x2B\x9D\xA8\x71"
            "\xF7\x36\x8D\x07\xEE\xD4\x10\x43\xA4\x40\xD6\xB6\xF0\x74\x54\xF5"
            "\x1F\xB8\xDF\xBA\xAF\x03\x5C\x02\xAB\x61\xEA\x48\xCE\xEB\x6F\xCD"
            "\x48\x76\xED\x52\x0D\x60\xE1\xEC\x46\x19\x71\x9D\x8A\x5B\x8B\x80"
            "\x7F\xAF\xB8\xE0\xA3\xDF\xC7\x37\x72\x3E\xE6\xB4\xB7\xD9\x3A\x25"
            "\x84\xEE\x6A\x64\x9D\x06\x09\x53\x74\x88\x34\xB2\x45\x45\x98\x39"
            "\x4E\xE0\xAA\xB1\x2D\x7B\x61\xA5\x1F\x52\x7A\x9A\x41\xF6\xC1\x68"
            "\x7F\xE2\x53\x72\x98\xCA\x2A\x8F\x59\x46\xF8\xE5\xFD\x09\x1D\xBD"
            "\xCB";

    static unsigned char e[] = "\x11";

    static unsigned char d[] =
        "\x00\xA5\xDA\xFC\x53\x41\xFA\xF2\x89\xC4\xB9\x88\xDB\x30\xC1\xCD"
        "\xF8\x3F\x31\x25\x1E\x06\x68\xB4\x27\x84\x81\x38\x01\x57\x96\x41"
        "\xB2\x94\x10\xB3\xC7\x99\x8D\x6B\xC4\x65\x74\x5E\x5C\x39\x26\x69"
        "\xD6\x87\x0D\xA2\xC0\x82\xA9\x39\xE3\x7F\xDC\xB8\x2E\xC9\x3E\xDA"
        "\xC9\x7F\xF3\xAD\x59\x50\xAC\xCF\xBC\x11\x1C\x76\xF1\xA9\x52\x94"
        "\x44\xE5\x6A\xAF\x68\xC5\x6C\x09\x2C\xD3\x8D\xC3\xBE\xF5\xD2\x0A"
        "\x93\x99\x26\xED\x4F\x74\xA1\x3E\xDD\xFB\xE1\xA1\xCE\xCC\x48\x94"
        "\xAF\x94\x28\xC2\xB7\xB8\x88\x3F\xE4\x46\x3A\x4B\xC8\x5B\x1C\xB3"
        "\xC1";
    
    RSAKey* key = [[RSAKey alloc] init];
    key.modulusData = [[NSData alloc] initWithBytes:n length:sizeof(n)-1];
    key.exponent_pub = [[NSData alloc] initWithBytes:e length:sizeof(e)-1];
    key.exponent_pri = [[NSData alloc] initWithBytes:d length:sizeof(d)-1];
    
    return key;
}

+ (RSAKey*)getKey2{
    NSString * modulus=@"9F35D1D1BB42C27C8B0367870CF45547E1204FBD3981117FD10AFB3C6FC3C6437396929F17EA5D7F02DB34E4D8D238F2E14411B7BE23168638BEA9742A5CF56CFD381D3E4D16F028A5F1CDDF8778879839374AF65DA9CFB70F1E275ABFC90E67922533C60641B2B134453721D6A889E89AA46E81BB15EF9C5F0B0E004A0260D1";
    NSString* exp = @"3f2ac94e9f2f839e8a4115883d998b64736bb0777123466021fe6b63b52c45b3695eea5978d1a1baccd5500d2401745ad9097ac61e0829dda311f28586714f66067eb6320a5a81e1f776a174dcfd11bf5cdf424731824d803c9899c9dd8a72ba50b215424dfe74ecf0859ead6e7b982c8932d3bf994d73073f5a8146203f3389";
    
    RSAKey* key = [[RSAKey alloc] init];
    key.modulusData = [Utils getBcdFromString:modulus];
    key.exponent_pub = [[NSData alloc]initWithBytes:"\x01\x00\x01" length:3];
    key.exponent_pri = [Utils getBcdFromString:exp];
    return key;
}

+ (RSAKey*)getKey3{
    NSString * modulus=@"c445488a607f621848568045c53479c3d1811027259d13700d9d44add48c985a1340b58849a4f3bc15d373e5153eb199a77184bde184a67989d01ca683551cf315edc5dc3daec24545f736b18ddfcb1428405ff392e9e223bed05d0146a080c949976fcf428655a4aba820711a9be45eacc89a58d57cf43a8cde4cb51ce63669";
    NSString* exp = @"3aad7bf95084c4d82236035a4648a9fa211f4719919c1205e4e7844e987d02587de9085cad5e9a36aa2b3b3add3a8ecbea5eea6bfed27bf2c7c9f95917fcd10ee7dbe8d472ea12a450e3100e77e5ccaf43a5403a5e34e7f2336357344f5bda3a246d96baab9c34c2078f2ecf7532650eb4d0399b93393c0a6911ebe6bbc2e1";
    RSAKey* key = [[RSAKey alloc] init];
    key.modulusData = [Utils getBcdFromString:modulus];
    key.exponent_pub = [[NSData alloc]initWithBytes:"\x01\x00\x01" length:3];
    key.exponent_pri = [Utils getBcdFromString:exp];
    return key;
}

+ (RSAKey*)getKeyWithIndex:(int)index{
    switch (index) {
        case 0:
            return [self getKey1];
        case 1:
            return [self getKey2];
        case 2:
            return [self getKey3];
    }
    return [[RSAKey alloc] init];
}

+ (NSString*)CryptData:(NSString*)plainText KeyIndex:(int)index Mode:(int)mode{
    NSData* plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    RSAKey* key = [self getKeyWithIndex:index];
    if(mode == 0){//公钥加密
        NSData* encryptData = [plainData OpenSSL_RSA_Encrypt_DataWithPublicModulus:key.modulusData exponent:key.exponent_pub];
        return [Utils getStringFromBcd:encryptData];
    }
    //私钥加密
    NSData* encryptData = [plainData OpenSSL_RSA_Encrypt_DataWithPrivateModulus:key.modulusData pubExponent:key.exponent_pub priExponent:key.exponent_pri];
    return [Utils getStringFromBcd:encryptData];
}

+ (NSString*)DecryptData:(NSString*)encryptText KeyIndex:(int)index Mode:(int)mode{
    NSData* encryptData = [Utils getBcdFromString:encryptText];
    RSAKey* key = [self getKeyWithIndex:index];
    if(mode == 0){
        //私钥解密
        NSData* decryptData = [encryptData OpenSSL_RSA_Decrypt_DataWithPrivateModulus:key.modulusData pubExponent:key.exponent_pub priExponent:key.exponent_pri];
        return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    }
    //公钥解密
    NSData* decryptData = [encryptData OpenSSL_RSA_Decrypt_DataWithPublicModulus:key.modulusData exponent:key.exponent_pub];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}
@end
