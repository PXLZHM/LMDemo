//
//  PhoneViewController.m
//  LMDemo
//
//  Created by xsy on 16/9/1.
//  Copyright © 2016年 pxl. All rights reserved.
//

#import "PhoneViewController.h"

@interface PhoneViewController ()

@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"callMin";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"callMin" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"min.jpeg"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 50;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
}

- (void)btnClick {
    NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",@"15755057230"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
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
