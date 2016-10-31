//
//  OCAndJSViewController.m
//  LMDemo
//
//  Created by xsy on 16/9/6.
//  Copyright © 2016年 pxl. All rights reserved.
//

#import "OCAndJSViewController.h"
#import "AllViewController.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.Height

@interface OCAndJSViewController ()
@property (nonatomic, strong) NSArray *arr;
@end

@implementation OCAndJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OC JS";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createBtn];
    
}

- (void)createBtn {
    CGFloat width = (ScreenW - 30) / 2;
    for (int i = 0; i < self.arr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10 + (width + 10) * (i % 2), 100 + (width + 10) * (i / 2), width, width);
        [btn setTitle:self.arr[i] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}



- (void)btnClick:(UIButton *)sender {
    AllViewController *vc;
    NSString *titleStr = self.arr[sender.tag - 100];
    switch (sender.tag) {
        case 100:
        {
            vc = [[AllViewController alloc] initWithOCJSType:OCJSTpyeJavaScriptCore title:titleStr];
            
            vc.allViewBlock = ^(NSString *str) {
                self.title = str;
            };
        }
            break;
        case 101:
        {
            vc = [[AllViewController alloc] initWithOCJSType:OCJSTpyeAgreement title:titleStr];
        }
            break;
        case 102:
        {
            vc = [[AllViewController alloc] initWithOCJSType:OCJSTpyeWebViewJavaScriptBridge title:titleStr];
        }
            break;
        case 103:
        {
            vc = [[AllViewController alloc] initWithOCJSType:OCJSTpyeWKWebView title:titleStr];
        }
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSArray *)arr {
    if (!_arr) {
        _arr = @[@"JavaScriptCore", @"拦截协议", @"WebViewJavaScriptBridge", @"WKWebView"];
    }
    return _arr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
