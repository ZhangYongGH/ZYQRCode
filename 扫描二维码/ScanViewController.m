//
//  ScanViewController.m
//  find
//
//  Created by zhangyong on 16/4/20.
//  Copyright © 2016年 zhangyong. All rights reserved.
//


#import "ScanViewController.h"


#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface ScanViewController ()

@end

@implementation ScanViewController

static const float kLineMinY = 100;
static const float kLineMaxY = 300;
static const float kReaderViewWidth = 200;
static const float kReaderViewHeight = 200;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        self.navigationItem.title = @"扫描设备编号";
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(0, 0, 40, 40);
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = left;
    }
    return self;
}
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Device
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    
    _output = [[AVCaptureMetadataOutput alloc]init];
    
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    [_output setRectOfInterest:CGRectMake(kLineMinY / SCREEN_HEIGHT, ((SCREEN_WIDTH - kReaderViewWidth) / 2.0) / SCREEN_WIDTH, kReaderViewHeight / SCREEN_HEIGHT, kReaderViewWidth / SCREEN_WIDTH)];
    // Session
    
    _session = [[AVCaptureSession alloc]init];
    
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])
        
    {
        
        [_session addInput:self.input];
        
    }
    
    if ([_session canAddOutput:self.output])
        
    {
        
        [_session addOutput:self.output];
        
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    
    _preview.frame = self.view.bounds;
    
    [self.view.layer insertSublayer:_preview atIndex:0];
    // Start
    
    [_session startRunning];
    [self setOverlayPickerView];
 


}
- (void)setOverlayPickerView
{
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kLineMinY)];//80
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMinY, (SCREEN_WIDTH - kReaderViewWidth) / 2.0, kReaderViewHeight)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - CGRectGetMaxX(leftView.frame), kLineMinY, CGRectGetMaxX(leftView.frame), kReaderViewHeight)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    CGFloat space_h = SCREEN_HEIGHT - kLineMaxY;
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMaxY, SCREEN_WIDTH, space_h)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //四个边角
    UIImage *cornerImage = [UIImage imageNamed:@"ScanQR1"];
    
    //左侧的view
    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    leftView_image.image = cornerImage;
    [self.view addSubview:leftView_image];
    
    cornerImage = [UIImage imageNamed:@"ScanQR2"];
    
    //右侧的view
    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    rightView_image.image = cornerImage;
    [self.view addSubview:rightView_image];
    
    cornerImage = [UIImage imageNamed:@"ScanQR3"];
    
    //底部view
    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    downView_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView_image];
    
    cornerImage = [UIImage imageNamed:@"ScanQR4"];
    
    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    downViewRight_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downViewRight_image];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 25, kReaderViewWidth, 20);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont boldSystemFontOfSize:13.0];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将二维码置于框内,即可自动扫描";
    [self.view addSubview:labIntroudction];
    
    UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - 1,kLineMinY,self.view.frame.size.width - 2 * CGRectGetMaxX(leftView.frame) + 2, kReaderViewHeight + 2)];
    scanCropView.layer.borderColor = [UIColor greenColor].CGColor;
    scanCropView.layer.borderWidth = 2.0;
    [self.view addSubview:scanCropView];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection

{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
        
    {
        //停止扫描
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
        stringValue = metadataObject.stringValue;

        //拿到扫描出来的字符串，block传出
        if (_urlBack) {
            _urlBack(stringValue);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
