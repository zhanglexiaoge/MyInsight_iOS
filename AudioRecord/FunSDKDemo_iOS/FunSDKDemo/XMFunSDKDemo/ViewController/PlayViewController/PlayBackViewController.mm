//
//  PlayBackViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/10/19.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "PlayBackViewController.h"
#import "PlayView.h"
#import "PlayFunctionView.h"
#import "PlayMenuView.h"
#import "DateSelectView.h"
#import "VideoFileConfig.h"
#import "MediaPlaybackControl.h"
#import "NSDate+TimeCategory.h"
#import "ProgressBackView.h"
#import "FishPlayControl.h"

@interface PlayBackViewController ()<DateSelectViewDelegate,VideoFileConfigDelegate,MediaplayerControlDelegate,basePlayFunctionViewDelegate,MediaPlayBackControlDelegate>
{
    PlayView *pVIew;                    //播放画面
    PlayFunctionView *toolView;         //工具栏
    PlayMenuView *playMenuView;         //下方功能栏
    ChannelObject *channel;             //选择播放的通道信息
    MediaPlaybackControl *mediaPlayer;  //播放媒体工具
    DateSelectView *dateView;           //时间选择器界面
    VideoFileConfig *videoConfig;       //录像文件管理器
    ProgressBackView *pBackView;        //时间轴所在的view
    FishPlayControl *feyeControl;       //鱼眼控制器
}

//导航栏右边的时间按钮
@property (nonatomic, strong) UIBarButtonItem *rightBarBtn;
//导航栏左边的返回按钮
@property (nonatomic, strong) UIBarButtonItem *leftBarBtn;
@end

@implementation PlayBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建导航栏
    [self setNaviStyle];
    
    //创建预览界面
    [self createPlayView];
    
    //创建时间轴背景view
    [self createProgressBackView];
    
    //创建工具栏界面
    [self createToolView];
    
    //创建一个隐藏的时间选择器界面
    [self createDateView];

    //获取要播放的设备信息
    [self initDataSource];
    
    //开始搜索录像文件
    [self startSearchFile];
}

#pragma mark - 开始播放视频
- (void)startSearchFile {
    pBackView.date = dateView.date;
    [videoConfig getDeviceVideoByTime:dateView.date];
}
#pragma mark - 预览对象初始化
- (void)initDataSource {
    channel = [[[DeviceControl getInstance] getPlayItem] firstObject];
    mediaPlayer = [[MediaPlaybackControl alloc] init];
    mediaPlayer.devID = channel.deviceMac;//设备序列号
    mediaPlayer.channel = channel.channelNumber;//当前通道号
    mediaPlayer.stream = 1;//辅码流
    mediaPlayer.renderWnd = pVIew;
    mediaPlayer.delegate = self;
    mediaPlayer.playbackDelegate = self;
    
    videoConfig = [[VideoFileConfig alloc] init];
    videoConfig.delegate = self;
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
    self.navigationItem.title = TS("Remote_View");
    self.rightBarBtn = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(pushToNextViewController)];
    
    self.navigationItem.rightBarButtonItem = self.rightBarBtn;
    self.rightBarBtn.width = 15;
    [self setBtnRightTitle:[NSDate date]];
    
    self.leftBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = self.leftBarBtn;
}

//设置当前选择的时间
-(void)setBtnRightTitle:(NSDate*)selectDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd"];
    self.rightBarBtn.title = [dateFormat stringFromDate:selectDate];
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
    [toolView setPlayMode:PLAYBACK_MODE];
}
#pragma mark - 创建一个隐藏的时间选择器界面
-(void)createDateView
{
    dateView = [[DateSelectView alloc] initWithFrame:CGRectMake(0, NavHeight , ScreenWidth, ScreenHeight - NavHeight)];
    dateView.delegate = self;
    [self.view addSubview:dateView];
}
#pragma mark - 创建时间轴背景view
-(void)createProgressBackView
{
    pBackView = [[ProgressBackView alloc] initWithFrame:CGRectMake(0, NavHeight + realPlayViewHeight + 60, ScreenWidth, ScreenHeight - NavHeight - realPlayViewHeight - NavHeight)];
    [self.view addSubview:pBackView];
    //滑动时间轴之后的回调
    __weak typeof(self) weakSelf = self;
    pBackView.TouchSeektoTime = ^ (NSInteger _add){
        [weakSelf touchAndSeekToTime:_add];
    };
}

#pragma mark - buttonEvent
#pragma mark 工具栏点击 - 暂停、音频、速度、抓图、录像
- (void)basePlayFunctionViewBtnClickWithBtn:(int)tag {
    if ((CONTROL_TYPE)tag == CONTROL_REALPLAY_CloseChannle) {
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
    }if ((CONTROL_TYPE)tag == CONTROL_TYPE_SPEED) {
        //点击速度切换按钮，1倍速度和2倍速度之间切换
        if(mediaPlayer.speed == MediaSpeedStateNormal){
            [mediaPlayer setPlaySpeed:1];
        }else{
            [mediaPlayer setPlaySpeed:0];
        }
       
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

#pragma mark  - 拖动时间轴切换播放时间，并且刷新播放状态
-(void)touchAndSeekToTime:(NSInteger)addTime
{
    pBackView.ifSliding = NO;
    [pVIew playViewBufferIng];
    [mediaPlayer seekToTime:addTime];
}
#pragma mark - 跳转到设备下一级界面
- (void)pushToNextViewController {
    if (dateView && dateView.hidden == YES) {
        [dateView dateSelectVIewShow];
        [self.view bringSubviewToFront:dateView];
    }
}
#pragma mark - 选择日期之后的接口方法
-(void)dateSelectedAction:(BOOL)Result
{
    if (Result == NO) {
        return;
    }
    //重新选择日期之后，开始搜索和播放的流程
    if ([NSDate checkDate:pBackView.date WithDate:dateView.date]) {
        //判断是否为同一天
        return;
    }
    [self setBtnRightTitle:dateView.date];
    
    //停止当前回放
    [mediaPlayer stopRecord];
    [self closeSound];
    [mediaPlayer refresh];
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [mediaPlayer stop];
     });
    
    [self startSearchFile];

}
#pragma mark - 返回设备列表界面
- (void)popViewController {
    [mediaPlayer stopRecord];
    [self closeSound];
    [mediaPlayer stop];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - funsdk回调
#pragma mark  录像按文件查询查询回调
- (void)getVideoResult:(NSInteger)result{
    if (result >= 0) {
        [pBackView refreshProgressWithSearchResult:[videoConfig getVideoTimeArray]];
       
        [pVIew playViewBufferIng];
        [mediaPlayer startPlayBack:dateView.date];
    }
    else{
        [SVProgressHUD showErrorWithStatus:TS("Video_Not_Found")];
    }
}

#pragma mark 通过搜索录像返回的时间来刷新时间轴
- (void)addTimeDelegate:(NSInteger)add{
    if (pBackView != nil) {
        [pBackView refreshWithAddTime:add];
    }
}

#pragma mark 录像回放时间帧回调，用来刷新label时间显示和时间轴
-(void)mediaPlayer:(MediaplayerControl *)mediaPlayer timeInfo:(int)timeinfo{
    if (pBackView != nil && pBackView.ifSliding == NO) {
        [pBackView refreshTimeAndProgress:timeinfo];
    }
}

#pragma mark - 开始预览结果回调
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer startResult:(int)result DSSResult:(int)dssResult {
    if (result < 0) {
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

#pragma mark 设置速度结果
-(void)setPlaySpeedResult:(int)result{
    if (result >= 0) {
        if(result == 0){
            mediaPlayer.speed = MediaSpeedStateNormal;
            [toolView refreshFunctionView:CONTROL_TYPE_SPEED result:NO];
        }else{
            mediaPlayer.speed = MediaSpeedStateAdd;
            [toolView refreshFunctionView:CONTROL_TYPE_SPEED result:YES];
        }
    }else{
        [MessageUI ShowErrorInt:result];
    }
}

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
#pragma mark 初始化鱼眼播放界面
-(void)createFeye:(int)Hardandsoft Hardmodel:(int)Hardmodel{
    [self.feyeControl createFeye:Hardandsoft frameSize:pVIew.frame];
    GLKViewController *glkVC= [self.feyeControl getFeyeViewController];
    [self addChildViewController:glkVC];
    [pVIew addSubview:glkVC.view];
    
    [self.feyeControl refreshSoftModel:(int)Hardandsoft model:Hardmodel];
}


@end
