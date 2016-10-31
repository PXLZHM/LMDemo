//
//  AllViewController.h
//  LMDemo
//
//  Created by xsy on 16/9/6.
//  Copyright © 2016年 pxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "JsObjCModel.h"




typedef enum : NSUInteger {
    OCJSTpyeJavaScriptCore,
    OCJSTpyeAgreement,
    OCJSTpyeWebViewJavaScriptBridge,
    OCJSTpyeWKWebView
} OCJSTpye;


@interface AllViewController : UIViewController

@property (nonatomic, copy) void(^allViewBlock) (NSString *str);
- (instancetype)initWithOCJSType:(OCJSTpye)type title:(NSString *)title;
@end
