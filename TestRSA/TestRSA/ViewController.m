//
//  ViewController.m
//  TestRSA
//
//  Created by macbook pro on 2020/12/15.
//

#import "ViewController.h"
#import "RSATest.h"

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
