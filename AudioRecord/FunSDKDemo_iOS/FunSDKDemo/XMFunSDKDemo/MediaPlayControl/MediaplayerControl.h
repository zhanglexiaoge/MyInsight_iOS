//
//  MediaplayerControl.h
//  FunSDKDemo
//
//  Created by XM on 2018/10/17.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 
 视频预览控制器，继承自 FunMsgListener
 1、视频预览，根据设备序列号和通道信息打开预览
 2、视频预览过程中的抓图录像暂停对讲云台控制等等操作
 *****/
#import "FunMsgListener.h"
#import "FunSDK/FunSDK.h"
//播放方式，实时预览和设备回放
enum MediaPlayerType{
    MediaPlayerTypeRealPlay,
    MediaPlayerTypePlayBack,
};
//播放状态，播放中、停止播放、暂停、恢复等等
enum MediaPlayerStatus {
    MediaPlayerStatusStop,
    MediaPlayerStatusBuffering,
    MediaPlayerStatusPlaying,
    MediaPlayerStatusPause,
};
//录像状态，录像中和非录像中
enum MediaRecordType{
    MediaRecordTypeNone,
    MediaRecordTypeRecording,
};
//音频状态  音频打开和关闭状态
enum MediaVoiceType{
    MediaVoiceTypeNone,
    MediaVoiceTypeVoice,
};
//对讲状态  对讲中和非对讲中
enum MediaTalkType{
    MediaTalkTypeNone,
    MediaTalkTypeTalking,
};
//播放速度
enum MediaSpeedState{
    MediaSpeedStateNormal,
    MediaSpeedStateAdd
};

@class MediaplayerControl;

@protocol MediaplayerControlDelegate <NSObject>
@optional

#pragma mark - 开始结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer startResult:(int)result DSSResult:(int)dssResult;

#pragma mark - 缓冲
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer buffering:(BOOL)isBuffering;

#pragma mark - 播放信息
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer info1:(int)nInfo info2:(NSString*)strInfo;

#pragma mark 收到暂停播放结果消息
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer pauseOrResumeResult:(int)result;

#pragma mark - 停止结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer stopResult:(int)result;

#pragma mark - 视频回放的时间
-(void)mediaPlayer:(MediaplayerControl *)mediaPlayer timeInfo:(int)timeinfo;

#pragma mark - 设备时间（鱼眼）
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer DevTime:(NSString *)time;

#pragma mark 收到刷新播放的结果消息
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer refreshPlayResult:(int)result;

#pragma mark 收到视频宽高比信息
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer width:(int)width htight:(int)height;

#pragma mark - 录像开始结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer startRecordResult:(int)result path:(NSString*)path;

#pragma mark - 录像结束结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer stopRecordResult:(int)result path:(NSString*)path;

#pragma mark 抓图结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer snapImagePath:(NSString *)path result:(int)result;

#pragma mark 抓取缩略图回调
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer thumbnailImagePath:(NSString *)path result:(int)result;

#pragma mark -鱼眼相关处理
#pragma mark 用户自定义信息帧回调
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer Hardandsoft:(int)Hardandsoft Hardmodel:(int)Hardmodel;
#pragma mark YUV数据回调
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer width:(int)width height:(int)height pYUV:(unsigned char *)pYUV;
#pragma mark 鱼眼软解
-(void)centerOffSetX:(MediaplayerControl*)mediaPlayer  offSetx:(short)OffSetx offY:(short)OffSetY  radius:(short)radius width:(short)width height:(short)height ;
#pragma mark 鱼眼画面智能分析报警自动旋转画面
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer AnalyzelLength:(int)length site:(int)type Analyzel:(char*)area;

@end

@interface MediaplayerControl : FunMsgListener

@property (nonatomic, assign) MediaPlayerType type;                 //媒体类型
@property (nonatomic, assign) MediaPlayerStatus status;            //播放状态
@property (nonatomic, assign) MediaRecordType record;            //录像状态
@property (nonatomic, assign) MediaVoiceType voice;  
@property (nonatomic, assign) MediaTalkType talk;            //对讲状态
@property (nonatomic, assign) MediaSpeedState speed;        // 播放速度状态
@property (nonatomic, copy) NSString* devID;                     //设备id
@property (nonatomic, assign) int channel;                       //通道号
@property (nonatomic, assign) int stream;                       //码流类型（0：主码流 1：副码流）
@property (nonatomic, assign) FUN_HANDLE player;                 //播放器句柄
@property (nonatomic, assign) UIView* renderWnd;                 //渲染窗体

@property (nonatomic, assign) BOOL IsYuv;   //是否是鱼眼模式

@property (nonatomic, weak) id<MediaplayerControlDelegate> delegate;  //代理

#pragma mark - 开启视频
-(int)start;
#pragma mark - 停止视频
-(int)stop;

#pragma mark - 暂停
-(int)pause;
#pragma mark - 恢复
-(int)resumue;

#pragma mark - 打开音频，传递音频大小，0-100
-(int)openSound:(int)soundValue;
#pragma mark - 关闭音频
-(int)closeSound;

#pragma mark - 抓图
-(int)snapImage;

#pragma mark - 开始录像
-(int)startRecord;
#pragma mark - 停止录像
-(int)stopRecord;

#pragma mark - 设置清晰度,0主码流，1辅码流，-1切换主辅码流
-(void)changeStream:(int)stream;

#pragma mark - 点击云台控制的按钮，开始控制     这个接口没有回调信息
-(void)controZStartlPTAction:(PTZ_ControlType)sender;
#pragma mark - 抬起云台控制的按钮，结束控制     这个接口没有回调信息
-(void)controZStopIPTAction:(PTZ_ControlType)sender;
#pragma mark FunSDK 结果
-(void)OnFunSDKResult:(NSNumber *)pParam;

@end
