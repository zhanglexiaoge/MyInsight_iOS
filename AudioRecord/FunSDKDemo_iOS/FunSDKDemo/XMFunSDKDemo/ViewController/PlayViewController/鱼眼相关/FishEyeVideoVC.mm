//
//  FishEyeVideoVC.m
//  未来家庭
//
//  Created by wujiangbo on 8/8/16.
//  Copyright © 2016 wujiangbo. All rights reserved.
//

#import "FishEyeVideoVC.h"
#import "FunSDK/FunSDK.h"
#import "FunSDK/XTypes.h"
//#import "OpenGLView.h"
//#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>
#include <queue>
#import "AppDelegate.h"
#import "VRGLViewController.h"
//#import "MacroDefinication.h"

#define RAD_TO_DEG( rad ) ( (rad) * 57.29577951f )
@interface FishEyeVideoVC ()
{
    
    
    VRGLViewController *SoftVR;//软解Glkview视图
    FUN_HANDLE player;                    //播放器句柄
    // UI_HANDLE msgHandle;
    UIImageView *backGroundImage;   // 背景图片
    int startTime;                  // 录像开始时间
    BOOL isPause;                   // 录像是否暂停
    UIView *_toolView;              // 工具栏
    UIView *_narView;               // 导航栏
    CGPoint     _touchBegPoint;
    CGPoint     _touchEndPoint;
    BOOL        _touched;
    NSInteger numbers;
    BOOL isMove;//判断手指停留 惯性停止
    BOOL isTouchMove;
    int Hardandsofts;//4:软解 3:硬解
    int Hardmodels;//模式
    short centerOffsetX;
    short centerOffsetY;
    short imageWidth;
    short imageHeight;
    short imgradius;
    UIPinchGestureRecognizer *twoFingerPinch ;
    
    int talkHandle;
}

@property(nonatomic,strong)UIView *gView;//显示播放视频的试图
@property (strong, nonatomic) EAGLContext *context;
@property(nonatomic)NSUInteger orietation;
@property (strong, nonatomic) NSDate *begDate;
@property (strong,nonatomic) NSDate *endDate;
@end

@implementation FishEyeVideoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    startTime = 0;
    isPause = NO;
    // 1.0 创建视图
    [self createBaseView];
    // 2.0 创建底部工具视图
    [self createToolView];
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    // 3.0 默认横屏播放
    //[self homeButtonLeft];
    self.playBtn.selected =NO;
    [self playVideo];
    [self addDoubleTapGesture];


}
-(void)addDoubleTapGesture
{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:doubleTap];
}
-(void)doubleTapAction:(UITapGestureRecognizer*)recognizer
{
    if (SoftVR) {
        [SoftVR DoubleTap:nil];
    }
}
-(void)tapGesture
{
    [self hiddenNav];
}
//隐藏状态栏和工具栏
-(void)hiddenNarViewAndToolView{
    _narView.hidden = YES;
    _toolView.hidden = YES;
}

//显示状态栏和工具栏
-(void)showNarViewAndToolView{
    _narView.hidden = NO;
    if (self.fisheyephotoOrvideo ==2) {
        _toolView.hidden =YES;
    }else{
        _toolView.hidden = NO;
        
    }
}

-(void)switchNarViewAndToolView {
    if (_narView.hidden == YES) {
        [self showNarViewAndToolView];
    } else {
        [self hiddenNarViewAndToolView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    FUN_MediaSetSound(player, 0, 0);
    FUN_MediaStop(player);
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.timeSlider.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame) + 20,20, ScreenWidth - CGRectGetMaxX(self.playBtn.frame) - 40 , 44);
}
#pragma mark - 创建基本视图
- (void)createBaseView
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    backGroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, ScreenWidth)];
    backGroundImage.image = [UIImage imageNamed:@"fisheye_video_background"];
    [self.view addSubview:backGroundImage];
    
    SoftVR = [[VRGLViewController alloc]init];
    [self addChildViewController:SoftVR];
    SoftVR.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:SoftVR.view];
    SoftVR.VRShowMode = 1;
    
    SoftVR.view.hidden = YES;
    _narView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, ScreenWidth)];
    [self.view addSubview:_narView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"new_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor = [UIColor clearColor];
    [_narView addSubview:backButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backButton.frame) + 10, 20, ScreenHeight - (CGRectGetMaxX(backButton.frame) + 10), 44)];
    self.titleLabel.text = [self.fileName lastPathComponent];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [_narView addSubview:self.titleLabel];
    
}

#pragma mark - createToolView
- (void)createToolView
{
//    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH - 80, SCREEN_HEIGHT, 80)];
//    if (SCREEN_WIDTH < SCREEN_HEIGHT) {
//        _toolView.frame = CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80);
//    }
//    [self.view addSubview:_toolView];
    
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth - 80, ScreenHeight, 80)];
    [self.view addSubview:_toolView];

    self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
    [self.playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn setImage:[UIImage imageNamed:@"fisheye_video_pouse"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"fisheye_video_play"] forState:UIControlStateSelected];
    [_toolView addSubview:self.playBtn];
    
    self.playTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playBtn.frame) + 20, 0, 100, 40)];
    self.playTime.textColor = [UIColor whiteColor];
    self.playTime.text = @"00:00";
    self.playTime.font = [UIFont systemFontOfSize:12];
    [_toolView addSubview:self.playTime];
    
    self.totalTime = [[UILabel alloc] initWithFrame:CGRectMake(ScreenHeight - 120, 0, 100, 40)];
    self.totalTime.textColor = [UIColor whiteColor];
    self.totalTime.textAlignment = NSTextAlignmentRight;
    self.totalTime.text = @"00:00";
    self.totalTime.font = [UIFont systemFontOfSize:12];
    [_toolView addSubview:self.totalTime];
    
    self.timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playBtn.frame) + 20,20, ScreenWidth - CGRectGetMaxX(self.playBtn.frame) - 40 , 44)];
    self.timeSlider.minimumTrackTintColor = [UIColor redColor];
    self.timeSlider.maximumTrackTintColor = [UIColor colorWithRed:68/255.0 green:71/255.0 blue:72/255.0 alpha:1];
    self.timeSlider.maximumValue = 30 * 60;
    [self.timeSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [_toolView addSubview:self.timeSlider];
    if (self.fisheyephotoOrvideo ==2) {
        _toolView.hidden =YES;
    }else{
        _toolView.hidden = NO;
        
    }
    
    
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    SoftVR.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    if (SoftVR) {
        [SoftVR configSoftEAGLContext];
    }
    //[SoftVR reloadInitView:SoftVR.view.frame];
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    
}

#pragma mark - 全屏播放
-(void)homeButtonLeft
{
    CGFloat number = 0;
    number = number + 90.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0];
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(number / 180.0 * M_PI );
    [_gView setTransform:rotate];
    [_toolView setTransform:rotate];
    [_narView setTransform:rotate];
    
    [UIView commitAnimations];
    
    _narView.center = CGPointMake(ScreenWidth - 20, ScreenWidth / 2);
    _toolView.center = CGPointMake(30, ScreenHeight/2);
    _gView.bounds = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
    _gView.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 0.5);
    
}

#pragma mark - UIControlEventValueChanged
- (void)sliderAction:(UISlider *)slider
{
    int f = slider.value;
    self.playTime.text = [self changeSecToTimeText:f];
    FUN_MediaSeekToTime(player,f, 0, 0);
    //FUN_MediaSeekToPos(handle,f * 100 / 25, 0);
}

#pragma mark - 将秒转化成显示的时间
- (NSString *)changeSecToTimeText:(int)second
{
    NSString *timeStr = @"";
    int min = (int)second/60;
    NSString *minStr;
    if (min < 10) {
        minStr = [NSString stringWithFormat:@"0%d",min];
    }
    else{
        minStr = [NSString stringWithFormat:@"%d",min];
    }
    int sec = second- ((int)second/60) * 60;
    NSString *secStr;
    if (sec < 10) {
        secStr = [NSString stringWithFormat:@"0%d",sec];
    }
    else{
        secStr = [NSString stringWithFormat:@"%d",sec];
    }
    
    timeStr = [NSString stringWithFormat:@"%@:%@",minStr,secStr];
    return timeStr;
}

#pragma mark - 播放／暂停按钮点击事件
- (void)playBtnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (self.playBtn.selected == NO && isPause == NO) {
        [self playVideo];
    }
    else{
        [self stopPlay];
    }
    
}
#pragma mark - 返回按钮点击事件
- (void)backAction:(UIButton *)sender
{
    
    [SoftVR removeFromParentViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 开始播放
- (void)playVideo{
    player = FUN_MediaLocRecordPlay(SELF, [self.fileName UTF8String] , (__bridge void*)_gView,0);
    FUN_MediaSetSound(player, 100, 0);
    
}

#pragma mark - 停止播放
- (void)stopPlay
{
    isPause = !isPause;
    FUN_MediaPause(player,-1);
}
#pragma mark - SDK 回调
-(void)OnFunSDKResult:(NSNumber *) pParam
{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    NSLog(@"-------------请求数据回调(tatal)---------------------");
    switch (msg->id) {
        case EMSG_ON_FRAME_USR_DATA:
        {
            if (msg -> param2 == 3) {
                SDK_FishEyeFrameHW fishFrame = {0};
                memcpy(&fishFrame, msg->pObject + 8, sizeof(SDK_FishEyeFrameHW));
                if (fishFrame.secene == SDK_FISHEYE_SECENE_P360_FE) {
                    Hardandsofts = 3;
                    FUN_SetIntAttr(player, EOA_MEDIA_YUV_USER, SELF);         // 返回Yuv数据
                    FUN_SetIntAttr(player, EOA_SET_MEDIA_VIEW_VISUAL, 0);       // 自己画画面
                    
                    
                }
                
            }else if ((msg->param2 == 4) && \
                      (msg->param1 >= (8 + sizeof(SDK_FishEyeFrameSW))))
            {
                SDK_FishEyeFrameSW fishFrame = {0};
                Hardandsofts =4;
                memcpy(&fishFrame, msg->pObject + 8, sizeof(SDK_FishEyeFrameSW));
                //
                //                FUN_SetIntAttr(player, EOA_MEDIA_YUV_USER, self.msgHandle);//返回Yuv数据
                //                FUN_SetIntAttr(player, EOA_SET_MEDIA_VIEW_VISUAL, 0);//自己画画面
                // 圆心偏差横坐标  单位:像素点
                centerOffsetX = fishFrame.centerOffsetX;
                //圆心偏差纵坐标  单位:像素点
                centerOffsetY = fishFrame.centerOffsetY;
                //半径  单位:像素点
                imgradius = fishFrame.radius;
                //圆心校正时的图像宽度  单位:像素点
                imageWidth = fishFrame.imageWidth;
                //圆心校正时的图像高度  单位:像素点
                imageHeight = fishFrame.imageHeight;
                //视角  0:俯视   1:平视
                if (fishFrame.viewAngle == 0) {
                    
                }
                //显示模式   0:360VR
                if (fishFrame.lensType == SDK_FISHEYE_LENS_360VR || fishFrame.lensType == SDK_FISHEYE_LENS_360LVR) {//360vr
                    [SoftVR setVRType:XMVR_TYPE_360D];
                }else{//180Vr
                    
                    [SoftVR setVRType:XMVR_TYPE_180D];
                }
                //设置鱼眼软解参数
                [SoftVR setVRFecParams:centerOffsetX yCenter:centerOffsetY radius:imgradius Width:imageWidth Height:imageHeight];
                SoftVR.view.hidden = NO;
                
            }
            SoftVR.view.hidden = NO;
            break;
        }
        case EMSG_ON_YUV_DATA://鱼眼灯泡或小雨点 p360模式 YUV数据回调
        {
            [SoftVR PushData:msg->param2 height:msg->param3 YUVData:(unsigned char *)msg->pObject];
            
        }
            break;
        case EMSG_START_PLAY://开始播放回
        {
            int time = msg->param3 - msg->param2 + 1;
            startTime = msg->param2;
            self.totalTime.text = [NSString stringWithFormat:@"%@",[self changeSecToTimeText:time]];
            self.timeSlider.maximumValue = time;
        }
            break;
        case EMSG_ON_PLAY_INFO: //收到解码信息回调
        {
            int playTime = msg->param2 - msg->param1;
            [self.timeSlider setValue:playTime animated:NO];
            self.playTime.text = [self changeSecToTimeText:playTime];
        }
            break;
        case EMSG_ON_PLAY_BUFFER_BEGIN:   // 正在缓存数据
        {
            NSLog(@"Buffer begin.....");
        }
            break;
        case EMSG_ON_PLAY_BUFFER_END:
        {
            
        }
            break;
        case EMSG_PAUSE_PLAY:
        {
            
        }
            break;
        case EMSG_ON_PLAY_END:              // 录像播放结束
        {
            self.playBtn.selected = !self.playBtn.selected;
            
            self.playTime.text = @"00:00";
            [self.timeSlider setValue:0 animated:NO];
        }
            break;
    }
}

//- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    [SoftVR SoftTouchMoveBegan:touches Softevent:event];
//    
//    
//}

-(void)hiddenNav
{
    _narView.hidden = !_narView.hidden;
    if (self.fisheyephotoOrvideo ==2) {
        
    }else{
        _toolView.hidden = !_toolView.hidden;
    }
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [SoftVR SoftTouchMove:touches Softevent:event];
    
}
//- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [SoftVR SoftTouchMoveEnd:touches Softevent:event];
//    for (UITouch *touch in touches) {
//        if (event.allTouches.count == 1 && touch.tapCount == 1)
//        {
//            [self hiddenNav];
//        }
//    }
//    
//}

//-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [SoftVR SoftTouchMoveEnd:touches Softevent:event];
//    for (UITouch *touch in touches) {
//        if (event.allTouches.count == 1 && touch.tapCount == 1)
//        {
//            [self hiddenNav];
//        }
//    }
//    
//}

-(NSInteger)comparebegtime{

    NSUInteger unitFlags =
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cps = [calendar components:unitFlags fromDate:self.begDate  toDate:self.endDate  options:0];
    return  [cps second];
    
}

- (void) touchesPinch:(UIPinchGestureRecognizer *)recognizer
{
    [SoftVR SoftTouchesPinch:recognizer.scale];
    
    return;
}

@end
