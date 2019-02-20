//
//  MediaPlaybackControl.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/27.
//  Copyright © 2018 wujiangbo. All rights reserved.
//
/***
 
视频回放控制器，视频回放流程包括
 1、查询这一天有没有录像文件（可以按时间和按文件查询）
 2、如果有文件，则根据需要进行按文件或者按时间进行回放（这里是按时间进行回放）
 3、回放开始之后，各种截图录像操作和预览一样
 *****/
#import "MediaplayerControl.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MediaPlayBackControlDelegate <NSObject>
#pragma mark 速度设置结果
-(void)setPlaySpeedResult:(int)result;
@optional
@end

@interface MediaPlaybackControl : MediaplayerControl

@property (nonatomic, weak) id<MediaPlayBackControlDelegate> playbackDelegate;  //代理
#pragma -mark 根据选择的日期调用回放接口
-(void)startPlayBack:(NSDate *)date;

#pragma mark - 根据传入的日期进行云视频回放（也可以自己设置时间段，这里是播放全天的云视频）
- (void)startPlayCloudVideo:(NSDate*)date;

#pragma mark - 停止
-(int)stop;

#pragma mark - 暂停
-(int)pause;

#pragma mark - 恢复
-(int)resumue;
#pragma mark - 清除画像缓存
-(void)refresh;

#pragma mark - 开始智能快放
-(int)setIntelPlay;
#pragma mark - 停止智能快放
-(int)stopIntelPlay;
#pragma mark - 拖动时间轴切换播放时间
-(void)seekToTime:(NSInteger)addtime;
#pragma mark - 设置播放速度(可设置1倍、2倍 、4倍，对应speed为0、1、2)
-(void)setPlaySpeed:(int)speed;
@end

NS_ASSUME_NONNULL_END
