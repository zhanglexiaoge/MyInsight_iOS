//
//  FFmpegVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/8.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "FFmpegVC.h"
#import "MIMovieObject.h"
#import <Masonry.h>
#import "UIColor+Category.h"

#define LERP(A,B,C) ((A)*(1.0-C)+(B)*C)

@interface FFmpegVC ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *fpsLabel;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *timerBtn;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) MIMovieObject *video;
@property (nonatomic, assign) float lastFrameTime;

@end

@implementation FFmpegVC

//@synthesize imageView, fpsLabel, playBtn, video;
/*
 [iOS开发 ( iPhone/iPad)：利用ffmpeg 实现音频解码、声音播放](https://blog.csdn.net/h_o_w_e/article/details/8780804)
 [一、视音频编解码技术零基础(理论总结)](https://juejin.im/post/5af185c86fb9a07aa43c2bf9)
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"FFmpeg";
    
    //[iOS上使用高大上的ffmpeg(一)——导入到iOS](https://www.jianshu.com/p/4811f11aed27)
    /***
     FFmpeg是一套可以用来记录、转换数字音频、视频,并能将其转化为流的开源计算机程序。采用LGPL或GPL许可证。
     它提供了录制、转换以及流化音视频的完整解决方案。它包含了非常先进的音频/视频编解码库libavcodec,为了保证高可移植性和编解码质量,libavcodec里很多codec都是从头开发的。
     FFmpeg在Linux平台下开发,但它同样也可以在其它操作系统环境中编译运行,包括Windows、Mac OS X等。这个项目最早由Fabrice Bellard发起,现在由Michael Niedermayer维护。
     许多FFmpeg的开发人员都来自MPlayer项目,而且当前FFmpeg也是放在MPlayer项目组的服务器上。项目的名称来自MPEG视频编码标准,前面的"FF"代表"Fast Forward"。
     简单来说，FFmpeg是一个免费的多媒体框架,可以运行音频和视频多种格式的录影、转换、流功能,能让用户访问几乎所有视频格式,包括mkv、flv、mov,VLC Media Player、Google Chrome浏览器都已经支持。
     ***/
    
    // 初始化Views
    [self creatUIViews];
    // 设置video
    [self setupFFmpeg];
}

#pragma mark - 创建UI视图
- (void)creatUIViews {
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    self.imageView.backgroundColor = [UIColor RandomColor];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.playBtn];
    self.playBtn.backgroundColor = [UIColor RandomColor];
    [self.playBtn setTitle:@"Play" forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    self.timerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.timerBtn];
    self.timerBtn.backgroundColor = [UIColor RandomColor];
    [self.timerBtn setTitle:@"Time" forState:UIControlStateNormal];
    [self.timerBtn addTarget:self action:@selector(timerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.fpsLabel = [[UILabel alloc] init];
    self.fpsLabel.backgroundColor = [UIColor RandomColor];
    [self.view addSubview:self.fpsLabel];
    self.fpsLabel.text = @"FPS 178";
    
    self.timerLabel = [[UILabel alloc] init];
    self.timerLabel.backgroundColor = [UIColor RandomColor];
    [self.view addSubview:self.timerLabel];
    self.timerLabel.text = @"00:00:46";
    
    // 设置代码约束
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.75f);
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(10.0f);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.5f);
    }];
    [self.timerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playBtn.mas_bottom).offset(5.0f);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.5f);
    }];
    [self.fpsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(10.0f);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.5f);
    }];
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fpsLabel.mas_bottom).offset(5.0f);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.5f);
    }];
}

- (void)setupFFmpeg {
    // 播放网络视频
    self.video = [[MIMovieObject alloc] initWithVideo:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"];
    
    // 播放本地视频
    //self.video = [[XYQMovieObject alloc] initWithVideo:[NSString bundlePath:@"Dalshabet.mp4"]];
    //self.video = [[XYQMoiveObject alloc] initWithVideo:@"/Users/king/Desktop/Stellar.mp4"];
    //self.video = [[XYQMoiveObject alloc] initWithVideo:@"/Users/king/Downloads/Worth it - Fifth Harmony ft.Kid Ink - May J Lee Choreography.mp4"];
    //self.video = [[XYQMoiveObject alloc] initWithVideo:@"/Users/king/Downloads/4K.mp4"];
    
    int tns, thh, tmm, tss;
    tns = self.video.duration;
    thh = tns / 3600;
    tmm = (tns % 3600) / 60;
    tss = tns % 60;
}

#pragma mark - 设置button的动作方法
- (void)playBtnAction:(UIButton *)button {
    NSLog(@"播放button的动作");
    [self.playBtn setEnabled:NO];
    
    // seek to 0.0 seconds
    [self.video seekTime:0.0];
    
    [NSTimer scheduledTimerWithTimeInterval: 1 / self.video.fps
                                     target:self
                                   selector:@selector(displayNextFrame:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)timerBtnAction:(UIButton *)button {
    NSLog(@"定时器button的动作");
    if (self.playBtn.enabled) {
        [self.video redialPaly];
        [self playBtnAction:self.playBtn];
    }
}

-(void)displayNextFrame:(NSTimer *)timer {
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    //self.TimerLabel.text = [NSString stringWithFormat:@"%f s",video.currentTime];
    self.timerLabel.text  = [self dealTime:self.video.currentTime];
    if (![self.video stepFrame]) {
        [timer invalidate];
        [self.playBtn setEnabled:YES];
        return;
    }
    
    self.imageView.image = self.video.currentImage;
    float frameTime = 1.0 / ([NSDate timeIntervalSinceReferenceDate] - startTime);
    if (self.lastFrameTime < 0) {
        self.lastFrameTime = frameTime;
    } else {
        self.lastFrameTime = LERP(frameTime, self.lastFrameTime, 0.8);
    }
    [self.fpsLabel setText:[NSString stringWithFormat:@"FPS %.0f",self.lastFrameTime]];
}

- (NSString *)dealTime:(double)time {
    
    int tns, thh, tmm, tss;
    tns = time;
    thh = tns / 3600;
    tmm = (tns % 3600) / 60;
    tss = tns % 60;
    
    //[ImageView setTransform:CGAffineTransformMakeRotation(M_PI)];
    return [NSString stringWithFormat:@"%02d:%02d:%02d",thh,tmm,tss];
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
