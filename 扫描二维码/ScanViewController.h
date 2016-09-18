//
//  ScanViewController.h
//  find
//
//  Created by zhangyong on 16/4/20.
//  Copyright © 2016年 zhangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice * device;

@property (strong,nonatomic)AVCaptureDeviceInput * input;

@property (strong,nonatomic)AVCaptureMetadataOutput * output;

@property (strong,nonatomic)AVCaptureSession * session;

@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

//扫描二维码得到的url链接传出去
@property (nonatomic,copy) void (^urlBack)(NSString *);




@end
