//
//  FingerPrintViewController.m
//  LMDemo
//
//  Created by xsy on 16/9/1.
//  Copyright © 2016年 pxl. All rights reserved.
//

#import "FingerPrintViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface FingerPrintViewController ()

@end

@implementation FingerPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"指纹解锁";
    
    //iOS8.0以后才支持指纹解锁
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        return;
    }
    [self zhiWenJieSuo];
    
    
    
    
    
    
    
    
    
    
    
    
    
}

- (void)zhiWenJieSuo {
    //创建LAContext
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *result = @"验证指纹";
    //使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                //验证成功，主线程刷新UI
                NSLog(@"验证成功");
            }else {
                
                NSLog(@"%@",error.localizedDescription);
                
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        //系统取消授权,如其他app切入
                        NSLog(@"系统取消授权");
                        break;
                    }
                        
                    case LAErrorUserCancel:
                    {
                        //用户取消验证Touch ID
                        NSLog(@"用户取消验证Touch ID");
//                        [self.navigationController popViewControllerAnimated:YES];
                        break;
                    }
                        
                    case LAErrorAuthenticationFailed:
                    {
                        //授权失败
                        NSLog(@"授权失败");
                        break;
                    }
                        
                    case LAErrorPasscodeNotSet:
                    {
                        //系统未设置密码
                        NSLog(@"系统未设置密码");
                        break;
                    }
                        
                    case LAErrorTouchIDNotAvailable:
                    {
                        //设备Touch ID不可用 如未打开
                        NSLog(@"设备Touch ID不可用");
                        break;
                    }
                        
                    case LAErrorTouchIDNotEnrolled:
                    {
                        //设备Touch ID不可用，用户未录入
                        NSLog(@"设备Touch ID不可用，用户未录入");
                        break;
                    }
                        
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换至主线程处理
                            
                        }];
                        NSLog(@"用户选择输入密码，切换至主线程处理");
                        break;
                    }
                        
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                        break;
                }
            }
        }];
    }else {
        //不支持指纹识别，LOG出错误详情
        NSLog(@"不支持指纹识别");
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID没有注册");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"没有设置密码");
                break;
            }
            default:
            {
                NSLog(@"TouchID不可用");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
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
