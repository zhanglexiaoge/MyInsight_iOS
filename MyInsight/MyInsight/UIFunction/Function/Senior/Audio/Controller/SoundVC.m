//
//  SoundVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/19.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "SoundVC.h"
#import <Masonry.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SoundVC ()

@property (nonatomic, strong) UIButton *playButton;

@end

@implementation SoundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"音效";
    
    [self creatSubViews];
    
    [self masonryLayout];
}

- (void)creatSubViews {
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.playButton];
    
    self.playButton.backgroundColor = [UIColor redColor];
    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)playButtonAction:(UIButton *)button {
    //
    [self playSoundEffect:@"alarm4.m4r"];
}

- (void)masonryLayout {
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.0f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.playButton.mas_width).multipliedBy(0.50);
    }];
}

- (void)playSoundEffect:(NSString *)name {
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    // 获取系统声音的ID
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    //AudioServicesPlayAlertSound(soundID);//播放音效并震动
}


void soundCompleteCallback(SystemSoundID soundID,void * clientData) {
    NSLog(@"播放完成...");
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
