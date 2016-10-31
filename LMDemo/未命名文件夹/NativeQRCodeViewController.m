//
//  NativeQRCodeViewController.m
//  LMDemo
//
//  Created by xsy on 16/10/10.
//  Copyright © 2016年 pxl. All rights reserved.
//

#import "NativeQRCodeViewController.h"
#import "PXLGenerateViewController.h"
#import "PXLScanningViewController.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface NativeQRCodeViewController ()
{
    UITextField *textField;
}
@end

@implementation NativeQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Native QRCode";
    self.view.backgroundColor = [UIColor whiteColor];
    [self customView];
    
    
}

- (void)customView {
    NSArray *titleArr = @[@"生成二维码", @"扫描二维码"];
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH / 2 - 60, (i % 2) * 120 + 120, 120, 120);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
//    textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 260, SCREEN_WIDTH - 20, 30)];
//    textField.placeholder = @"输入银行卡号";
//    textField.textContentType = UITextContentTypeStreetAddressLine2;
//    [self.view addSubview:textField];
}

- (void)buttonClick:(UIButton *)sender {
    UIViewController *vc;
    if (sender.tag == 100) {
        vc = [[PXLGenerateViewController alloc] initWithNibName:@"PXLGenerateViewController" bundle:nil];
    }else {
        vc = [[PXLScanningViewController alloc] initWithNibName:@"PXLScanningViewController" bundle:nil];
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (BOOL)isBankCard:(NSString *)idCard {
    if (idCard.length == 0) {
        return NO;
    }
    
    NSString *cardOnly = @"";
    char a;
    for (int i = 0; i < idCard.length; i ++) {
        a = [idCard characterAtIndex:i];
        if (isdigit(a)) {
            cardOnly = [cardOnly stringByAppendingFormat:@"%c",a];
        }
    }
    
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    
    for (NSInteger i = cardOnly.length - 1; i >= 0; i--)
    {
        digit = [cardOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
