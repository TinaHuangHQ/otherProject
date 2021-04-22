//
//  ViewController.m
//  EncryptDemo
//
//  Created by macbook pro on 2021/4/22.
//

#import "ViewController.h"
#import "EncryptionTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * key = @"abc";
    uint8_t iv[8] = {1,2,3,4,5,6,7,8};
    NSData * ivData = [NSData dataWithBytes:iv length:sizeof(iv)];
    NSString* pwd = @"hello";
    
    [self testDES_ECB:pwd andKey:key];
    [self testDES_CBC:pwd andKey:key andIv:ivData];
    [self testAES_ECB:pwd andKey:key];
    [self testAES_CBC:pwd andKey:key andIv:ivData];
    
}

- (void)testDES_ECB:(NSString*)pwd andKey:(NSString*)key{
    [EncryptionTools sharedEncryptionTools].algorithm = kCCAlgorithmDES;
    NSString * encStr = [[EncryptionTools sharedEncryptionTools] encryptString:pwd keyString:key iv:nil];
    NSLog(@"[DES_ECB]加密的结果是：%@",encStr);
    
    NSLog(@"[DES_ECB]解密的结果是：%@",[[EncryptionTools sharedEncryptionTools] decryptString:encStr keyString:key iv:nil]);
}

- (void)testDES_CBC:(NSString*)pwd andKey:(NSString*)key andIv:(NSData*)iv{
    [EncryptionTools sharedEncryptionTools].algorithm = kCCAlgorithmDES;
    NSString * encStr = [[EncryptionTools sharedEncryptionTools] encryptString:pwd keyString:key iv:iv];
    NSLog(@"[DES_CBC]加密的结果是：%@",encStr);
    
    NSLog(@"[DES_CBC]解密的结果是：%@",[[EncryptionTools sharedEncryptionTools] decryptString:encStr keyString:key iv:iv]);
}

- (void)testAES_ECB:(NSString*)pwd andKey:(NSString*)key{
    [EncryptionTools sharedEncryptionTools].algorithm = kCCAlgorithmAES;
    NSString * encStr = [[EncryptionTools sharedEncryptionTools] encryptString:pwd keyString:key iv:nil];
    NSLog(@"[AES_ECB]加密的结果是：%@",encStr);
    
    NSLog(@"[AES_ECB]解密的结果是：%@",[[EncryptionTools sharedEncryptionTools] decryptString:encStr keyString:key iv:nil]);
}

- (void)testAES_CBC:(NSString*)pwd andKey:(NSString*)key andIv:(NSData*)iv{
    [EncryptionTools sharedEncryptionTools].algorithm = kCCAlgorithmAES;
    NSString * encStr = [[EncryptionTools sharedEncryptionTools] encryptString:pwd keyString:key iv:iv];
    NSLog(@"[AES_CBC]加密的结果是：%@",encStr);
    
    NSLog(@"[AES_CBC]解密的结果是：%@",[[EncryptionTools sharedEncryptionTools] decryptString:encStr keyString:key iv:iv]);
}

@end
