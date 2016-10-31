//
//  JsObjCModel.m
//  LMDemo
//
//  Created by xsy on 16/9/7.
//  Copyright © 2016年 pxl. All rights reserved.
//

#import "JsObjCModel.h"

@interface JsObjCModel ()<JsObjCModelDelegate>
@property (nonatomic, weak) JSContext *jsContext;

@end

@implementation JsObjCModel
- (void)callSystemCamera {
    NSLog(@"调用相册了");
}

- (void)mySunShine:(NSString *)str {
    NSLog(@"!!!!  %@",str);
    
}
@end
