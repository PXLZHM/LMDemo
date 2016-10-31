//
//  JsObjCModel.h
//  LMDemo
//
//  Created by xsy on 16/9/7.
//  Copyright © 2016年 pxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

@protocol JsObjCModelDelegate <JSExport>

//js调用此方法来调用oc的系统相册
- (void)callSystemCamera;

- (void)mySunShine:(NSString *)str;

@end

@interface JsObjCModel : NSObject
@property (nonatomic, weak) JSContext *context;
@property (nonatomic, weak) UIWebView *webView;
@end
