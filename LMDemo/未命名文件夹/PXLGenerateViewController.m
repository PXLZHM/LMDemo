//
//  PXLGenerateViewController.m
//  LMDemo
//
//  Created by xsy on 16/10/10.
//  Copyright © 2016年 pxl. All rights reserved.
//

#import "PXLGenerateViewController.h"

@interface PXLGenerateViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIImageView *codeImg;

@end

@implementation PXLGenerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"生成二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupGenerateQRCode];
    
}


/**
 生成一般的二维码
 */
- (void)setupGenerateQRCode {
    // 1.设置滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2.转换数据
    NSData *data = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 3.获取滤镜输出对象
    CIImage *outImage = [filter outputImage];
    
    // 4.讲CIImage转换成UIImage并放大显示
    self.codeImg.image = [self createNonInterpolatedWithCIImage:outImage Size:CGRectGetWidth(self.codeImg.frame)];
    
    
}





/** 将CIImage转换成UIImage */
- (UIImage *)createNonInterpolatedWithCIImage:(CIImage *)ciImg Size:(CGFloat)size {
    
    CGRect extent = CGRectIntegral(ciImg.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImg fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - getter
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
    }
    return _textField;
}

- (UIImageView *)codeImg {
    if (!_codeImg) {
        _codeImg = [[UIImageView alloc] init];
    }
    return _codeImg;
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
