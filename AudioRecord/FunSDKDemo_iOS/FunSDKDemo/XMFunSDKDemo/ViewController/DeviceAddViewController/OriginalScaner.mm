//
//  OriginalScaner.m
//  未来家庭
//
//  Created by Megatron on 11/6/15.
//  Copyright © 2015 Megatron. All rights reserved.
//

#import "OriginalScaner.h"
#import <CoreMedia/CMSync.h>
#import <AVFoundation/AVFoundation.h>
#import "ScanAnimationView.h"
#import "AppDelegate.h"

@interface OriginalScaner ()<AVCaptureMetadataOutputObjectsDelegate>{
    ScanAnimationView *_animatoinView;
}

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@end

#define TopHeight 124
#define ScanWidth 220

@implementation OriginalScaner

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int cccolor = 20;
    float alpha = 0.7;
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TopHeight)];
    viewTop.backgroundColor = [UIColor colorWithRed:cccolor/255.0 green:cccolor/255.0 blue:cccolor/255.0 alpha:alpha];
    [self.view addSubview:viewTop];
    
    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, TopHeight, (ScreenWidth - ScanWidth) / 2.0, ScreenHeight - TopHeight)];
    viewLeft.backgroundColor = [UIColor colorWithRed:cccolor/255.0 green:cccolor/255.0 blue:cccolor/255.0 alpha:alpha];
    [self.view addSubview:viewLeft];
    
    UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(ScanWidth +(ScreenWidth - ScanWidth) / 2.0, TopHeight, (ScreenWidth - ScanWidth) / 2.0, ScreenHeight - TopHeight)];
    viewRight.backgroundColor = [UIColor colorWithRed:cccolor/255.0 green:cccolor/255.0 blue:cccolor/255.0 alpha:alpha];
    [self.view addSubview:viewRight];
    
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - ScanWidth) / 2.0, TopHeight + ScanWidth, ScanWidth, ScreenHeight - TopHeight + ScanWidth)];
    viewBottom.backgroundColor = [UIColor colorWithRed:cccolor/255.0 green:cccolor/255.0 blue:cccolor/255.0 alpha:alpha];
    [self.view addSubview:viewBottom];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScanWidth, 50)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:15];
    lab.text = TS("qr_scan_tips");

    lab.numberOfLines = 0;
    [lab sizeToFit];

    [viewBottom addSubview:lab];
    
    [self setNaviStyle];
    
    _animatoinView = [[ScanAnimationView alloc] initWithFrame:CGRectMake((ScreenWidth - ScanWidth) / 2.0, TopHeight, ScanWidth, ScanWidth)];
    
    [self.view addSubview:_animatoinView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_animatoinView startScanAnimation];
    });
    
    self.view.backgroundColor=[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self startReadingMachineReadableCodeObjects:@[AVMetadataObjectTypeQRCode] inView:self.view];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:@"MyAppWillBecomeInactive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:@"MyAppWillBecomeActive" object:nil];
}

#pragma mark - 设置导航栏
- (void)setNaviStyle {
    self.navigationItem.title = TS("scan_code");
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

#pragma mark - button event
-(void)popViewController
{
    [self stopReading];
    
    if (self.myScanerQuitBlock) {
        self.myScanerQuitBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)appWillResignActive
{
    [self stopReading];
}

-(void)appDidBecomeActive
{
    [_animatoinView startScanAnimation];
    
    [self startReadingMachineReadableCodeObjects:@[AVMetadataObjectTypeQRCode] inView:self.view];
}

// 开始扫描
- (void)startReadingMachineReadableCodeObjects:(NSArray *)codeObjects inView:(UIView *)preview {
    // 摄像头设备
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    // 设置输入口
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error || !input) {
        NSLog(@"error: %@", [error description]);
        return;
    }
    
    // 会话session, 把输入口加入会话 
    self.session = [[AVCaptureSession alloc] init];
    [self.session addInput:input];// 将输入添加到session
    
    // 设置输出口，加入session, 设置输出口参数
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setRectOfInterest:CGRectMake(( TopHeight )/ ScreenHeight ,(( ScreenWidth - ScanWidth )/ 2 )/ ScreenWidth , 220 / ScreenHeight , 220 / ScreenWidth )];
    
    [self.session addOutput:output];
    
    [output setMetadataObjectTypes:codeObjects];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()]; // 使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    
    // 设置展示层(预览层)
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];// 设置预览层信息
    [self.preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    self.preview.frame = [UIScreen mainScreen].bounds;
    
    [preview.layer insertSublayer:self.preview atIndex:0]; //添加至视图
    
    [self beginReading];
}

// 启动session
- (void)beginReading
{
    [self.session startRunning];
}

// 关闭session
- (void)stopReading
{
    [self.session stopRunning];
    [self.preview removeFromSuperlayer];
}

// 识别到二维码 并解析转换为字符串
#pragma mark -
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self stopReading];
    
    AVMetadataObject *metadata = [metadataObjects objectAtIndex:0];
    NSString *codeStr= nil;
    if ([metadata respondsToSelector:@selector(stringValue)]) {
        codeStr = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
    }
    
    if (self.myScanerFinishedBlock) {
        self.myScanerFinishedBlock(codeStr);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
