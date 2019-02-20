//
//  PlayViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/23.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "PlayViewController.h"
#import "DeviceConfigViewController.h"
#import "PlayBackViewController.h"
#import "MediaplayerControl.h"
#import "PlayView.h"
#import "PlayFunctionView.h"
#import "PlayMenuView.h"
#import "TalkView.h"
#import "PTZView.h"
#import "TalkBackControl.h"
#import "FishPlayControl.h"
#import "VRGLViewController.h"
#import "HardVRViewController.h"
#import "UILabelOutLined.h"
#import "DeviceManager.h"

@interface PlayViewController () <MediaplayerControlDelegate,basePlayFunctionViewDelegate,PlayMenuViewDelegate,TalKViewDelegate,PTZViewDelegate>
{
    PlayView *pVIew;  //播放画面
    VRGLViewController *softV;//鱼眼软解播放画面，（绝大部分设备都是软解）
    HardVRViewController *hardV; //鱼眼硬解播放画面
    PlayFunctionView *toolView; // 工具栏
    PlayMenuView *playMenuView;//下方功能栏
    TalkView *talkView;//对讲功能界面
    PTZView *ptzView; //云台控制界面
    ChannelObject *channel; //选择播放的通道信息
    MediaplayerControl  *mediaPlayer;//播放媒体工具
    TalkBackControl *talkControl;//对讲工具
    
    FishPlayControl *feyeControl;
    int Hardandsofts;//鱼眼解码模式 4:软解 3:硬解
    int Hardmodels;//鱼眼画面模式
    int shapeType; //吸顶模式还是壁挂模式
    BOOL isFeyeYuv;//是否是鱼眼预览
    short centerOffsetX; //鱼眼偏移量参数
    short centerOffsetY;
    short imageWidth; //语言宽高参数
    short imageHeight;
    short imgradius; //鱼眼半径参数
    UILabelOutLined *timeLab;
    UILabelOutLined *nameLab;
}

//导航栏右边的设置按钮
@property (nonatomic, strong) UIBarButtonItem *rightBarBtn;
//导航栏左边的返回按钮
@property (nonatomic, strong) UIBarButtonItem *leftBarBtn;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建导航栏;
    [self setNaviStyle];
    
    //创建预览界面
    [self createPlayView];
    
    //获取要播放的设备信息
    [self initDataSource];
    
    //创建工具栏界面
    [self createToolView];
    
    //创建下方功能栏
    [self createPlayMenuView];
    
    //开始播放视频
    [self startRealPlay];
}

#pragma mark - 开始播放视频
- (void)startRealPlay {
    [pVIew playViewBufferIng];
    [mediaPlayer start];
}
#pragma mark 切换码流
-(void)changeStreamType {
    //如果正在录像、对讲、播放音频，需要先停止这几项操作
    [self stopRecord];
    [self closeSound];
    [self stopTalk];
    //先停止预览
     [mediaPlayer stop];
    //切换主辅码流
    if (mediaPlayer.stream == 0) {
        mediaPlayer.stream = 1;
    }else if (mediaPlayer.stream == 1) {
        mediaPlayer.stream = 0;
    }
    //重新播放预览
    [mediaPlayer start];
    //刷新主辅码流显示
    [playMenuView setStreamType:mediaPlayer.stream];
}
#pragma mark - 工具栏点击 - 暂停、音频、抓图、录像
- (void)basePlayFunctionViewBtnClickWithBtn:(int)tag {
    if ((CONTROL_TYPE)tag == CONTROL_FULLREALPLAY_PAUSE) {
        //点击暂停按钮，暂停预览
        if (mediaPlayer.status == MediaPlayerStatusPlaying) {
            [mediaPlayer pause];
        }else if (mediaPlayer.status == MediaPlayerStatusPause) {
             [mediaPlayer resumue];
        }
    }if ((CONTROL_TYPE)tag == CONTROL_REALPLAY_VOICE) {
        //点击音频按钮，打开音频
        if (mediaPlayer.voice == MediaVoiceTypeNone) {
            //音频没有回调，所以直接在这里刷新界面
            [self openSound];
        }else if (mediaPlayer.voice == MediaVoiceTypeVoice){
            [self closeSound];
        }
    }if ((CONTROL_TYPE)tag == CONTROL_REALPLAY_TALK) {
        //点击对讲按钮,打开对讲
        [self presentTalkView];
    }if ((CONTROL_TYPE)tag == CONTROL_REALPLAY_SNAP) {
        //开始抓图
        [mediaPlayer snapImage];
    }if ((CONTROL_TYPE)tag == CONTROL_REALPLAY_VIDEO) {
        //开始和停止录像
        if (mediaPlayer.record == MediaRecordTypeNone) {
            [mediaPlayer startRecord];
        }else if (mediaPlayer.record == MediaRecordTypeRecording){
            [mediaPlayer stopRecord];
        }
    }
}
#pragma mark 停止录像
- (void)stopRecord {
    if (mediaPlayer.record == MediaRecordTypeNone) {
        [mediaPlayer stopRecord];
    }
}
#pragma mark 停止播放音频
- (void)closeSound {
    if (mediaPlayer.voice == MediaVoiceTypeVoice){
        [mediaPlayer closeSound];
        mediaPlayer.voice = MediaVoiceTypeNone;
        [toolView refreshFunctionView:CONTROL_REALPLAY_VOICE result:NO];
    }
}
#pragma mark 开始播放音频
- (void)openSound {
    if (mediaPlayer.voice == MediaVoiceTypeNone){
        [mediaPlayer openSound:100];
        mediaPlayer.voice = MediaVoiceTypeVoice;
        [toolView refreshFunctionView:CONTROL_REALPLAY_VOICE result:YES];
    }
}
#pragma mark  停止对讲
- (void)stopTalk {
    //停止对讲
    [talkControl stopTalk];
    if (talkView) {
         [talkView cannelTheView];
    }
}
#pragma mark - 开始预览结果回调
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer startResult:(int)result DSSResult:(int)dssResult {
    if (result < 0) {
        if(result == EE_DVR_PASSWORD_NOT_VALID)//密码错误，弹出密码修改框
        {
            [SVProgressHUD dismiss];
            ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
            DeviceObject *device = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:TS("EE_DVR_PASSWORD_NOT_VALID") message:channel.deviceMac preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = TS("set_new_psd");
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:TS("Cancel") style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:TS("OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UITextField *passWordTextField = alert.textFields.firstObject;
                DeviceManager *manager = [DeviceManager getInstance];
                //点击确定修改密码
                [manager changeDevicePsw:channel.deviceMac loginName:device.loginName password:passWordTextField.text];
                //开始播放视频
                [self startRealPlay];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        [MessageUI ShowErrorInt:result];
    }else {
         if (dssResult == 3) { //DSS 打开视频成功
             
         }else if (dssResult == 5){//RPS打开预览成功
             
         }
        [pVIew playViewBufferIng];
    }
}

#pragma mark - 视频缓冲中
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer buffering:(BOOL)isBuffering {
    if (isBuffering == YES) {//开始缓冲
        [pVIew playViewBufferIng];
    }else{//缓冲完成
        [pVIew playViewBufferEnd];
    }
}

#pragma mark 收到暂停播放结果消息
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer pauseOrResumeResult:(int)result {
    if (result == 2) { //暂停预览
        mediaPlayer.status = MediaPlayerStatusPause;
        [toolView refreshFunctionView:CONTROL_FULLREALPLAY_PAUSE result:YES];
    }else if (result == 1){ //恢复预览
        mediaPlayer.status = MediaPlayerStatusPlaying;
         [toolView refreshFunctionView:CONTROL_FULLREALPLAY_PAUSE result:NO];
    }
}
#pragma mark - 录像开始结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer startRecordResult:(int)result path:(NSString*)path {
     if (result == EE_OK) { //开始录像成功
         mediaPlayer.record = MediaRecordTypeRecording;
         [toolView refreshFunctionView:CONTROL_REALPLAY_VIDEO result:YES];
     }else{
         [MessageUI ShowErrorInt:result];
         [toolView refreshFunctionView:CONTROL_REALPLAY_VIDEO result:NO];
     }
}
#pragma mark - 录像结束结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer stopRecordResult:(int)result path:(NSString*)path {
    if (result == EE_OK) { //结束录像成功
        [SVProgressHUD showSuccessWithStatus:TS("Success") duration:2.0];
    }else{
        [MessageUI ShowErrorInt:result];
    }
     [toolView refreshFunctionView:CONTROL_REALPLAY_VIDEO result:NO];
    mediaPlayer.record = MediaRecordTypeNone;
}

#pragma mark 抓图结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer snapImagePath:(NSString *)path result:(int)result {
    if (result == EE_OK) { //抓图成功
        [SVProgressHUD showSuccessWithStatus:TS("Success") duration:2.0];
    }else{
        [MessageUI ShowErrorInt:result];
    }
}

#pragma mark 收到视频宽高比信息
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer width:(int)width htight:(int)height {
    
}
#pragma mark -鱼眼视频预览相关处理 （非鱼眼设备可以不用考虑下列几个方法）
UIPinchGestureRecognizer *twoFingerPinch;//硬解码捏合手势
#pragma mark 用户自定义信息帧回调，通过这个判断是什么模式在预览
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer Hardandsoft:(int)Hardandsoft Hardmodel:(int)Hardmodel {
    if (Hardandsoft == 3 || Hardandsoft == 4 || Hardandsoft == 5) {
        //创建鱼眼预览界面
        [self createFeye:Hardandsoft Hardmodel:Hardmodel];
    }
}
#pragma mark YUV数据回调
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer width:(int)width height:(int)height pYUV:(unsigned char *)pYUV {
        [self.feyeControl PushData:width height:height YUVData:pYUV];
}
#pragma mark - 设备时间（鱼眼）
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer DevTime:(NSString *)time {
        [self.feyeControl setTimeLabelText:time];
}
#pragma mark 鱼眼软解坐标参数
-(void)centerOffSetX:(MediaplayerControl*)mediaPlayer  offSetx:(short)OffSetx offY:(short)OffSetY  radius:(short)radius width:(short)width height:(short)height {
        [self.feyeControl centerOffSetX:OffSetx offY:OffSetY radius:radius width:width height:height];
}
#pragma mark 鱼眼画面智能分析报警自动旋转画面
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer AnalyzelLength:(int)length site:(int)type Analyzel:(char*)area {
    
}

#pragma mark - 预览对象初始化
- (void)initDataSource {
    channel = [[[DeviceControl getInstance] getPlayItem] firstObject];
    mediaPlayer = [[MediaplayerControl alloc] init];
    mediaPlayer.devID = channel.deviceMac;//设备序列号
    mediaPlayer.channel = channel.channelNumber;//当前通道号
    mediaPlayer.stream = 1;//辅码流
    mediaPlayer.renderWnd = pVIew;
    mediaPlayer.delegate = self;
    //初始化对讲工具，这个可以放在对讲开始前初始化
    talkControl = [[TalkBackControl alloc] init];
    talkControl.deviceMac = mediaPlayer.devID;
    talkControl.channel = mediaPlayer.channel;
}
-(FishPlayControl*)feyeControl{
    if (feyeControl == nil) {
        feyeControl = [[FishPlayControl alloc] init];
    }
    return feyeControl;
}

#pragma mark - 界面初始化
- (void)createPlayView {
    pVIew = [[PlayView alloc] initWithFrame:CGRectMake(0, NavAndStatusHight, ScreenWidth, realPlayViewHeight)];
    [self.view addSubview:pVIew];
    [pVIew refreshView];
}
- (void)setNaviStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = TS("Real_Time_Video");
    self.rightBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Local_Settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToDeviceConfigViewController)];
    self.navigationItem.rightBarButtonItem = self.rightBarBtn;
    self.rightBarBtn.width = 15;
    
    self.leftBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = self.leftBarBtn;
}

#pragma mark - 创建工具栏
-(void)createToolView{
    if (!toolView) {
        toolView = [[PlayFunctionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ToolViewHeight)];
        toolView.Devicedelegate = self;
    }
    toolView.hidden = NO;
    toolView.playMode = REALPLAY_MODE;
    toolView.screenVertical = YES;
    [toolView showPlayFunctionView];
    toolView.frame = CGRectMake(0, NavAndStatusHight+ realPlayViewHeight, ScreenWidth, ToolViewHeight);
    [self.view addSubview:toolView];
    [toolView setPlayMode:REALPLAY_MODE];
}

-(void)createPlayMenuView {
    if (!playMenuView) {
        playMenuView = [[PlayMenuView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ToolViewHeight)];
        playMenuView.delegate = self;
    }
    float height = (ScreenHeight - NavHeight - realPlayViewHeight - ToolViewHeight);
    playMenuView.frame = CGRectMake(0, NavAndStatusHight+ realPlayViewHeight+ToolViewHeight, ScreenWidth, height);
    [self.view addSubview:playMenuView];
}
#pragma mark 初始化鱼眼播放界面
-(void)createFeye:(int)Hardandsoft Hardmodel:(int)Hardmodel{
    [self.feyeControl createFeye:Hardandsoft frameSize:pVIew.frame];
    GLKViewController *glkVC= [self.feyeControl getFeyeViewController];
    [self addChildViewController:glkVC];
    [pVIew addSubview:glkVC.view];
    
    [self.feyeControl refreshSoftModel:(int)Hardandsoft model:Hardmodel];
}
////初始化鱼眼播放界面
//-(void)createFeye:(int)type {
//    if (timeLab == nil) {
//        timeLab = [[UILabelOutLined alloc] initWithFrame:CGRectMake(ScreenWidth-160 , 0, 150, 30)];
//        timeLab.textAlignment = NSTextAlignmentRight;
//        [pVIew addSubview:timeLab];
//    }
//    if (nameLab == nil) {
//        nameLab = [[UILabelOutLined alloc] initWithFrame:CGRectMake(10 , 0, 150, 30)];
//        nameLab.textAlignment = NSTextAlignmentLeft;
//        [pVIew addSubview:nameLab];
//        [pVIew insertSubview:nameLab belowSubview:timeLab];
//    }
//    if (type == 3) {
//        if (hardV == nil) {
//            hardV = [[HardVRViewController alloc] init];
//            [self addChildViewController:hardV];
//            hardV.view.hidden = YES;
//            [pVIew addSubview:hardV.view];
//        }
//        [pVIew insertSubview:hardV.view belowSubview:timeLab];
//    }
//    else if (type == 4 || type == 5)     {
//        if (softV == nil) {
//            softV = [[VRGLViewController alloc] init];
//            [self addChildViewController:softV];
//            softV.view.hidden = YES;
//            [pVIew addSubview:softV.view];
//        }
//
//        [pVIew insertSubview:softV.view belowSubview:timeLab];
//    }
//        CGRect rect = pVIew.frame;
//        rect.origin.x=0;
//        rect.origin.y=0;
//        softV.view.frame = rect;
//        hardV.view.frame = rect;
//}

#pragma mark - 跳转到设备配置界面
- (void)pushToDeviceConfigViewController {
    DeviceConfigViewController *devConfigVC = [[DeviceConfigViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:devConfigVC animated:YES];
}

#pragma mark - 显示云台控制器
-(void)showPTZControl{
    if (ptzView == nil) {
        ptzView = [[PTZView alloc] initWithFrame:CGRectMake(0, ScreenHeight-150, ScreenWidth, 150)];
        ptzView.PTZdelegate = self;
        ptzView.speedDelegate = self;
    }
    [self.view addSubview:ptzView];
}
#pragma mark  显示对讲画面
-(void)presentTalkView{
    if (talkView == nil) {
        talkView = [[TalkView alloc]init];
        talkView.frame = CGRectMake(0, ScreenHeight - 150 , ScreenWidth, 150);
        talkView.delegate = self;
        [self.view addSubview:talkView];
        [talkView showTheView];
        [toolView refreshFunctionView:CONTROL_REALPLAY_TALK result:YES];
    }else{
        [talkView cannelTheView];
        [self closeTalkView];
    }
}
#pragma mark - 云台控制按钮的代理  云台控制方法没有回调
//方向控制点击
-(void)controlPTZBtnTouchDownAction:(int)sender{
    [mediaPlayer controZStartlPTAction:(PTZ_ControlType)sender];
}
//方向控制抬起
-(void)controlPTZBtnTouchUpInsideAction:(int)sender{
    [mediaPlayer controZStopIPTAction:(PTZ_ControlType)sender];
}
//点击控制的按钮(变倍，变焦，光圈)
-(void)controladdSpeedTouchDownAction:(int)sender{
    [mediaPlayer controZStartlPTAction:(PTZ_ControlType)sender];
}
//抬起控制的按钮(变倍，变焦，光圈)
-(void)controladdSpeedTouchUpInsideAction:(int)sender{
   [mediaPlayer controZStopIPTAction:(PTZ_ControlType)sender];
}

#pragma - mark - 语音对讲按钮代理
- (void)openTalk {
   talkControl.handle = mediaPlayer.msgHandle;
    [talkControl startTalk];
    [toolView refreshFunctionView:CONTROL_REALPLAY_VOICE result:NO];
}
- (void)closeTalk {
    talkControl.handle = mediaPlayer.msgHandle;
    [talkControl stopTalk];
    [toolView refreshFunctionView:CONTROL_REALPLAY_VOICE result:YES];
}
#pragma mark 隐藏对讲画面
-(void)closeTalkView {
    //停止对讲
    talkControl.handle = mediaPlayer.msgHandle;
    [talkControl stopTalk];
    [toolView refreshFunctionView:CONTROL_REALPLAY_TALK result:NO];
    [toolView refreshFunctionView:CONTROL_REALPLAY_VOICE result:NO];
    talkView = nil;
}
#pragma mark - 跳转到视频回放界面
-(void)presentPlayBackViewController {
    PlayBackViewController *playBack = [[PlayBackViewController alloc] init];
    [self.navigationController pushViewController:playBack animated:YES];
}

#pragma mark - 返回设备列表界面
- (void)popViewController {
    [mediaPlayer stop];
    [[DeviceControl getInstance] cleanPlayitem];
    [self.navigationController popViewControllerAnimated:YES];
}
@end

