//
//  ViewController.m
//  HashDemo
//
<<<<<<< HEAD
//  Created by Qiong Huang on 2021/4/21.
//

#import "ViewController.h"

@interface ViewController ()

@end

=======
//  Created by macbook pro on 2021/4/21.
//

#import "ViewController.h"
#import "NSString+Hash.h"

@interface ViewController ()

@property(nonatomic, strong)NSString* pwd;

@end

static NSString * salt = @"LKSJDFLKJ&^&@@";
static NSString * key = @"huang";

>>>>>>> 5850f3240cef0e081e0e94e7459f66be5f30e8b8
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
<<<<<<< HEAD
}

=======
    NSString* pwd = @"123456";
    [self testMD5:pwd];
    [self testMD5Salt:pwd];
    [self testHmac:pwd];
    [self testHmacTime:pwd];
    [self testSha1:pwd];
    [self testSha256:pwd];
    [self testSha512:pwd];
}

- (void)testMD5:(NSString*)pwd{
    NSLog(@"密码(MD5)：%@",pwd.md5String);
}

- (void)testMD5Salt:(NSString*)pwd{
    pwd = [pwd stringByAppendingString:salt].md5String;
    NSLog(@"密码(MD5Salt)：%@",pwd);
}

- (void)testHmac:(NSString*)pwd{
    pwd = [pwd hmacMD5StringWithKey:key];
    NSLog(@"密码(Hmac)：%@", pwd);
}

- (void)testHmacTime:(NSString*)pwd{
    pwd = [pwd hmacMD5StringWithKey:key];
    pwd = [pwd stringByAppendingString:@"202104211811"].md5String;
    NSLog(@"密码(Time)：%@", pwd);
}

- (void)testSha1:(NSString*)pwd{
    NSLog(@"密码(Sha1)：%@", pwd.sha1String);
}

- (void)testSha256:(NSString*)pwd{
    NSLog(@"密码(Sha256)：%@", pwd.sha256String);
}

- (void)testSha512:(NSString*)pwd{
    NSLog(@"密码(Sha512)：%@", pwd.sha512String);
}
>>>>>>> 5850f3240cef0e081e0e94e7459f66be5f30e8b8

@end
