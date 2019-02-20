//
//  XMPlayerVC.m
//  XWorld_General
//
//  Created by SaturdayNight on 2018/8/6.
//  Copyright © 2018年 xiongmaitech. All rights reserved.
//

#import "XMPlayerVC.h"
#import <FunSDK/FunSDK.h>
#import "CYGLKView.h"

@interface XMPlayerVC ()

@property (nonatomic,strong) UIButton *btnBack;         // 返回按钮
@property (nonatomic,strong) UILabel *lbBackTitle;      // 标题

@property (nonatomic,strong) UIView *playerMenu;        // 播放菜单
@property (nonatomic,strong) UISlider *sliderVideo;     // 进度条
@property (nonatomic,strong) UILabel *lbTimeLeft;
@property (nonatomic,strong) UILabel *lbTimeRight;
@property (nonatomic,strong) UIButton *btnPlay;

@property (nonatomic,assign) BOOL isPause;              // 是否暂停
@property (nonatomic,assign) int startTime;             // 录像开始时间

@property (nonatomic,strong) CYGLKView *glView;         // 视频显示
@property (strong, nonatomic) EAGLContext *context;
@property (nonatomic,assign) int msgHandle;
@property (nonatomic,assign) FUN_HANDLE player;         // 播放器句柄

@end

@implementation XMPlayerVC

-(instancetype)init{
    self= [super init];
    self.msgHandle = FUN_RegWnd((__bridge LP_WND_OBJ)self);
    
    return self;
}

-(void)dealloc{
    FUN_UnRegWnd(self.msgHandle);
    self.msgHandle = -1;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.glView];
    [self.view addSubview:self.btnBack];
    [self.view addSubview:self.lbBackTitle];
    
    [self.view addSubview:self.playerMenu];
    [self.view addSubview:self.sliderVideo];
    [self.view addSubview:self.lbTimeLeft];
    [self.view addSubview:self.lbTimeRight];
    [self.view addSubview:self.btnPlay];
    [self myLayout];
    
    [self playVideo];
}

#pragma mark - EventAction
-(void)btnBackClicked{
    FUN_MediaSetSound(self.player, 0, 0);
    FUN_MediaStop(self.player);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 播放／暂停按钮点击事件
- (void)playBtnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (self.btnPlay.selected == NO && self.isPause == NO) {
        [self playVideo];
    }
    else{
        [self pauseOrResumePlay];
    }
}

#pragma mark - 开始播放
-(void)playVideo
{
    self.player = FUN_MediaLocRecordPlay(self.msgHandle, [self.filePath UTF8String] , (__bridge void*)(self.glView),0);
    
    FUN_MediaSetSound(self.player, 100, 0);
}

#pragma mark - UIControlEventValueChanged
-(void)sliderValueChanged:(UISlider *)slider {
    self.lbTimeLeft.text = [self changeSecToTimeText:slider.value];
}

-(void)sliderTouchDown:(UISlider *)slider {
    [self pauseOrResumePlay];
}

- (void)sliderAction:(UISlider *)slider
{
    [self pauseOrResumePlay];
    FUN_MediaSeekToTime(self.player,self.sliderVideo.value, 0, 0);
}

#pragma mark - 暂停恢复播放
- (void)pauseOrResumePlay
{
    self.isPause = !self.isPause;
    FUN_MediaPause(self.player,-1);
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

#pragma mark - FunSDK CallBack
-(void)OnFunSDKResult:(NSNumber *) pParam
{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch (msg->id) {
        case EMSG_START_PLAY://开始播放回
        {
            int time = msg->param3 - msg->param2 + 1;
            self.startTime = msg->param2;
            self.lbTimeRight.text = [NSString stringWithFormat:@"%@",[self changeSecToTimeText:time]];
            self.sliderVideo.maximumValue = time;
            NSLog(@"开始\np1------%d\np2------%d\np3------%d",msg->param1,msg->param2,msg->param3);
        }
            break;
        case EMSG_ON_PLAY_INFO: //收到解码信息回调
        {
            int playTime = msg->param2 - msg->param1;
            [self.sliderVideo setValue:playTime animated:NO];
            self.lbTimeLeft.text = [self changeSecToTimeText:playTime];
            NSLog(@"播放\np1------%d\np2------%d\np3------%d",msg->param1,msg->param2,msg->param3);
        }
            break;
        case EMSG_ON_PLAY_END:              // 录像播放结束
        {
            self.btnPlay.selected = !self.btnPlay.selected;
            
            self.lbTimeLeft.text = @"00:00";
            [self.sliderVideo setValue:0 animated:NO];
            FUN_MediaStop(self.player);
            NSLog(@"结束\np1------%d\np2------%d\np3------%d",msg->param1,msg->param2,msg->param3);
        }
            break;
            default:
            break;
    }
}

-(void)myLayout{
    self.btnBack.frame = CGRectMake(10, 15, 45, 40);
    self.lbBackTitle.frame = CGRectMake(70, 15, ScreenWidth - 140, 40);
    self.glView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth * 0.75);
    self.glView.center = self.view.center;
    self.playerMenu.frame = CGRectMake(10, ScreenHeight -80, ScreenWidth - 20, 70);

    self.sliderVideo.frame = CGRectMake(30,ScreenHeight - 60, ScreenWidth - 60, 10);
    self.lbTimeLeft.frame = CGRectMake(20, ScreenHeight - 50, 100, 30);
    self.lbTimeRight.frame = CGRectMake(ScreenWidth -120, ScreenHeight - 50, 100, 30);
    self.btnPlay.frame = CGRectMake(ScreenWidth/2 - 20, ScreenHeight - 50, 30, 30);
}

#pragma mark - LazyLoad
-(CYGLKView *)glView{
    if (!_glView) {
        _glView = [[CYGLKView alloc] init];
        _glView.backgroundColor = [UIColor blackColor];
    }
    
    return _glView;
}

-(UIButton *)btnBack{
    if (!_btnBack) {
        _btnBack = [[UIButton alloc] init];
        [_btnBack setBackgroundImage:[UIImage imageNamed:@"new_back.png"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnBack;
}

-(UILabel *)lbBackTitle{
    if (!_lbBackTitle) {
        _lbBackTitle = [[UILabel alloc] init];
        _lbBackTitle.textColor = [UIColor whiteColor];
        _lbBackTitle.textAlignment = NSTextAlignmentCenter;
        _lbBackTitle.text = [self.filePath lastPathComponent];
    }
    
    return _lbBackTitle;
}

-(UIView *)playerMenu{
    if (!_playerMenu) {
        _playerMenu = [[UIView alloc] init];
        _playerMenu.backgroundColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
        _playerMenu.layer.cornerRadius = 5;
        _playerMenu.layer.masksToBounds = YES;
    }
    
    return _playerMenu;
}

-(UISlider *)sliderVideo{
    if (!_sliderVideo) {
        _sliderVideo = [[UISlider alloc] init];
        _sliderVideo.minimumTrackTintColor = [UIColor redColor];
        _sliderVideo.maximumTrackTintColor = [UIColor colorWithRed:68/255.0 green:71/255.0 blue:72/255.0 alpha:1];
        _sliderVideo.maximumValue = 30 * 60;
        [_sliderVideo addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_sliderVideo addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_sliderVideo addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sliderVideo addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpOutside];
    }
    
    return _sliderVideo;
}

-(UILabel *)lbTimeLeft{
    if (!_lbTimeLeft) {
        _lbTimeLeft = [[UILabel alloc] init];
        _lbTimeLeft.textColor = [UIColor whiteColor];
        _lbTimeLeft.text = @"00:00";
        _lbTimeLeft.font = [UIFont systemFontOfSize:12];
    }
    
    return _lbTimeLeft;
}

-(UILabel *)lbTimeRight{
    if (!_lbTimeRight) {
        _lbTimeRight = [[UILabel alloc] init];
        _lbTimeRight.textColor = [UIColor whiteColor];
        _lbTimeRight.textAlignment = NSTextAlignmentRight;
        _lbTimeRight.text = @"00:00";
        _lbTimeRight.font = [UIFont systemFontOfSize:12];
    }
    
    return _lbTimeRight;
}

-(UIButton *)btnPlay{
    if (!_btnPlay) {
        _btnPlay = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnPlay addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnPlay setImage:[UIImage imageNamed:@"fisheye_video_pouse"] forState:UIControlStateNormal];
        [_btnPlay setImage:[UIImage imageNamed:@"fisheye_video_play"] forState:UIControlStateSelected];
    }
    
    return _btnPlay;
}

@end
