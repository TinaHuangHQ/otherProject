//
//  ViewController.m
//  TestRSA
//
//  Created by macbook pro on 2020/12/15.
//

#import "ViewController.h"
#import "RSATest.h"
#import "RSACryptor.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *EncryptKeySegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *KeyIndexSegment;
@property (weak, nonatomic) IBOutlet UITextField *PlainText;
@property (weak, nonatomic) IBOutlet UITextView *EncryptText;
@property (weak, nonatomic) IBOutlet UIButton *EncryptBtn;
@property (weak, nonatomic) IBOutlet UIButton *DecryptBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.加载公钥
    [[RSACryptor sharedRSACryptor] loadPublicKey:[[NSBundle mainBundle] pathForResource:@"rsacert.der" ofType:nil]];
    //2.加载私钥
    [[RSACryptor sharedRSACryptor] loadPrivateKey: [[NSBundle mainBundle] pathForResource:@"p.p12" ofType:nil] password:@"123456"];
}

static void my_encrypt(){
    NSData * result = [[RSACryptor sharedRSACryptor] encryptData:[@"hello" dataUsingEncoding:NSUTF8StringEncoding]];
    //base64编码
    NSString * base64 = [result base64EncodedStringWithOptions:0];
    NSLog(@"加密之后:%@\n",base64);
    
    //解密
    NSData * dcStr = [[RSACryptor sharedRSACryptor] decryptData:result];
    NSLog(@"解密之后:%@",[[NSString alloc] initWithData:dcStr encoding:NSUTF8StringEncoding]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    my_encrypt();
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (IBAction)EncryptOnClick:(id)sender {
    if(self.PlainText.text.length <= 0){
        return;
    }
    self.EncryptText.text = @"";
    int index = (int)self.KeyIndexSegment.selectedSegmentIndex;
    int mode = (int)self.EncryptKeySegment.selectedSegmentIndex;
    self.EncryptText.text = [RSATest CryptData:self.PlainText.text KeyIndex:index Mode:mode];
}

- (IBAction)DecryptOnClick:(id)sender {
    if(self.EncryptText.text.length <= 0){
        return;
    }
    self.PlainText.text = @"";
    int index = (int)self.KeyIndexSegment.selectedSegmentIndex;
    int mode = (int)self.EncryptKeySegment.selectedSegmentIndex;
    self.PlainText.text = [RSATest DecryptData:self.EncryptText.text KeyIndex:index Mode:mode];
}

- (NSString*)getPromptStringWithMode:(int)mode index:(int)index{
    NSMutableString* str = [[NSMutableString alloc] init];
    [str appendString:@"当前加密模式:"];
    if(mode == 0){
        [str appendString:@"公钥加密，私钥解密"];
    }
    else{
        [str appendString:@"私钥加密，公钥解密"];
    }
    [str appendString:@"\n"];
    [str appendString:@"当前密钥索引:"];
    [str appendString:[NSString stringWithFormat:@"%d", index]];
    return [str copy];
}

@end
