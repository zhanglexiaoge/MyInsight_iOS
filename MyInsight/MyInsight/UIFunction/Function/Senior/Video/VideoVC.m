//
//  VideoVC.m
//  MyInsight
//
//  Created by SongMengLong on 2018/9/18.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "VideoVC.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoVC ()
// 播放器
@property (nonatomic, retain) AVPlayer *player;
// 播放对象
@property (nonatomic, strong) AVPlayerItem *playerItem;
//显示视频的层
@property (nonatomic,retain)AVPlayerLayer *playerLayer;
//视频播放进度
@property (weak, nonatomic) IBOutlet UISlider *videoSlider;
//判断是否已经开始播放O
@property (nonatomic,assign)BOOL isReayToPlay;
//显示事件的label
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,retain)NSTimer *timer;

@end

@implementation VideoVC

/*
 另外AVPlayer是一个可以播放任何格式的全功能影音播放器
 支持视频格式： WMV，AVI，MKV，RMVB，RM，XVID，MP4，3GP，MPG等。
 支持音频格式：MP3，WMA，RM，ACC，OGG，APE，FLAC，FLV等。
 */

/*
 AVPlayer：控制播放器的播放，暂停，播放速度
 AVURLAsset : AVAsset 的一个子类，使用 URL 进行实例化，实例化对象包换 URL 对应视频资源的所有信息。
 AVPlayerItem：管理资源对象，提供播放数据源
 AVPlayerLayer：负责显示视频，如果没有添加该类，只有声音没有画面
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"视频";
    
    self.isReayToPlay = NO;
    
    [self netVideoPlay];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressAction) userInfo:nil repeats:YES];
    
}

#pragma mark - 得到视频
- (void)netVideoPlay {
    NSString *urlStr = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    //NSString *urlStr2 = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"mp4"];
    
    // 播放下一个视频
    // [_player replaceCurrentItemWithPlayerItem: nextPlayerItem];
    
    // 得到视频资源的URL
    NSURL *videoURL = [NSURL fileURLWithPath:urlStr];
    // 初始化item
    self.playerItem = [[AVPlayerItem alloc] initWithURL:videoURL];
    // 初始化播放器
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    // 显示图像的layer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //将视频层添加到当前解密的layer上
    [self.view.layer addSublayer:self.playerLayer];
    //self.playerLayer.frame = CGRectMake(0, 0, 200, 200);
    self.playerLayer.frame = self.view.frame;
    //
    self.player.volume = 1.0f;
    
    //让视频层适应当前界面
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    //为item添加观察者，当视频已经准备好播放的时候再播放
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    // 可播放可录音，更可以后台播放，还可以在其他程序播放的情况下暂停播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                   error:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 移除通知
    [self.playerLayer removeFromSuperlayer];
    // 停掉playeritem的网络请求释放掉playerintm 就不会再出现这种问题了
    [self.playerItem cancelPendingSeeks];
    [self.playerItem.asset cancelLoading];
    // 加这两行代码，将正在播放的 item 释放掉
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    
    //[self.player removeTimeObserver:<#(nonnull id)#>]
    self.playerLayer = nil;
    self.player = nil;
    self.playerItem = nil;
}

#pragma mark - KVO方法回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem*)object;
    NSLog(@"item -- %@",item);
    
    // 取出变化之后的属性值
    NSLog(@"new -- %@ ",change[NSKeyValueChangeNewKey]);
    // 取出变化之前的
    NSLog(@"old -- %@",change[NSKeyValueChangeOldKey]);
    // 得到改变后的status
    AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
    // 对比，看目前播放单元的状态
    switch (status) {
        case AVPlayerItemStatusUnknown:
        NSLog(@"未知状态");
        break;
        case AVPlayerItemStatusFailed:
        NSLog(@"失败");
        break;
        case AVPlayerItemStatusReadyToPlay:
        {
            NSLog(@"准备好播放");
            [self.player play];
            self.isReayToPlay = YES;
        }
        break;
        default:
        break;
    }
    // 视频的总长度
    float second = self.playerItem.duration.value/self.playerItem.duration.timescale;
    NSLog(@"视频长度 %f",second);
    // 设置滑竿的最大值
    self.videoSlider.maximumValue = second;
    self.videoSlider.minimumValue = 0;
    // 移除观察者
    [item removeObserver:self forKeyPath:@"status"];
}

// 进度条的回调方法
-(void)changeProgress:(UISlider*)sender {
    //每次调整之前，暂停播放
    [self.player pause];
    if (self.isReayToPlay) {
        //说明已经有时长了，可以进行操作
        //设置播放的区间
        //参数1.CMTime从哪个时刻开始播放
        //参数2.回调，设置完成后要进行的动作
        [self.player seekToTime:CMTimeMakeWithSeconds(sender.value, self.playerItem.currentTime.timescale) completionHandler:^(BOOL finished) { if (finished) {
            //调整已经结束，可以播放了
            [self.player play];
            }}];
        
    }}

// 进度条根据播放进度变动
-(void)progressAction {
    //label显示当前时间
    NSDate *currentTime =[NSDate dateWithTimeIntervalSinceReferenceDate:round(_playerItem.currentTime.value/_playerItem.currentTime.timescale)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    _timeLabel.text=[formatter stringFromDate:currentTime];
    //进度条变动
    _videoSlider.value = _playerItem.currentTime.value/_playerItem.currentTime.timescale;
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
