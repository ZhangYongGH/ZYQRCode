//
//  ViewController.m
//  扫描二维码
//
//  Created by zhangyong on 16/4/20.
//  Copyright © 2016年 zhangyong. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"


@interface ViewController ()
{
    //扫一扫按钮
    UIButton *_btn;
    
    //生成二维码
    UIButton *_imageBtn;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 60)];
    [self.view addSubview:_btn];
    _btn.backgroundColor = [UIColor blueColor];
    [_btn setTitle:@"扫一扫" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_btn.frame) + 20, 200, 60)];
    [self.view addSubview:_imageBtn];
    
    _imageBtn.backgroundColor = [UIColor redColor];
    [_imageBtn setTitle:@"生成二维码" forState:UIControlStateNormal];
    [_imageBtn addTarget:self action:@selector(imageBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
}


#pragma mark - 集成扫描二维码功能


//扫描二维码
- (void)btnTap:(UIButton *)button{
    
    
#if TARGET_IPHONE_SIMULATOR//模拟器
    NSLog(@"当前设备不支持摄像头");
    
#elif TARGET_OS_IPHONE//真机
    ScanViewController *vc = [[ScanViewController alloc] init];
    
    //block拿到扫描二维码生成的url
    [vc setUrlBack:^(NSString *code) {
        
        NSLog(@"%@",code);
        
        NSURL * url = [NSURL URLWithString: code];
        
        if ([[UIApplication sharedApplication] canOpenURL: url]) {
            [[UIApplication sharedApplication] openURL: url];
        } else {
            
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat: @"%@:%@", @"无法解析的二维码", code] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alertView addAction:cancelAction];
            
            [self presentViewController:alertView animated:YES completion:nil];
            
        }
        
    }];
    
    
    [self presentViewController:vc animated:YES completion:nil];
    
#endif
    
    
}



#pragma mark - 集成生成二维码功能

//原生oc生成二维码，需要导入CoreImage.framework框架
- (void)imageBtn:(UIButton *)button{
    
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 3. 将获得的字符串转换成NSData
    NSString *str = @"http://www.mtime.com";
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
//    // 6. 将CIImage转换成UIImage，并放大显示
//    UIImage *getImage = [UIImage imageWithCIImage:outputImage scale:20.0 orientation:UIImageOrientationUp];
    
    
    //创建imageView,展示生成的二维码
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 200, 200)];
    [self.view addSubview:imageView];
    imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:100];
    
    
    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    
    imageView.layer.shadowOffset=CGSizeMake(0, 0.5);//设置阴影的偏移量
    
    imageView.layer.shadowRadius=1;//设置阴影的半径
    
    imageView.layer.shadowColor=[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
    
    imageView.layer.shadowOpacity=0.3;
    
    
}

//改变二维码大小和清晰度
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}



@end
