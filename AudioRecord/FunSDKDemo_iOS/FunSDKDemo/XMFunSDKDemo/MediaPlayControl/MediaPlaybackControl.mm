//
//  MediaPlaybackControl.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/27.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "MediaPlaybackControl.h"
#import "NSDate+TimeCategory.h"

@implementation MediaPlaybackControl
{
    H264_DVR_FINDINFO Info;
}

#pragma -mark 根据选择的日期调用回放接口
-(void)startPlayBack:(NSDate *)date{
    struct H264_DVR_FINDINFO requestInfo;
    memset(&requestInfo, 0, sizeof(H264_DVR_FINDINFO));
    requestInfo.nChannelN0 = self.channel;
    requestInfo.nFileType = 0;
    requestInfo.startTime.dwYear = [NSDate getYearFormDate:date];
    requestInfo.startTime.dwMonth = [NSDate getMonthFormDate:date];
    requestInfo.startTime.dwDay = [NSDate getDayFormDate:date];
    requestInfo.startTime.dwHour = 0;
    requestInfo.startTime.dwMinute = 0;
    requestInfo.startTime.dwSecond = 0;
    
    requestInfo.endTime.dwYear = [NSDate getYearFormDate:date];
    requestInfo.endTime.dwMonth = [NSDate getMonthFormDate:date];
    requestInfo.endTime.dwDay = [NSDate getDayFormDate:date];
    requestInfo.endTime.dwHour = 23;
    requestInfo.endTime.dwMinute = 59;
    requestInfo.endTime.dwSecond = 59;
    [self start:requestInfo];
}
#pragma mark - 开启
-(int)start:(H264_DVR_FINDINFO)findInfo{
    Info = findInfo;
    return [self start];
}
-(int)start
{
    self.player = FUN_MediaNetRecordPlayByTime(self.msgHandle, [self.devID UTF8String], &Info, (__bridge LP_WND_OBJ)self.renderWnd);
    //[super start];
    return self.player;
}

#pragma mark - 根据传入的日期进行云视频回放（也可以自己设置时间段，这里是播放全天的云视频）
- (void)startPlayCloudVideo:(NSDate*)date {
    SDK_SYSTEM_TIME beginTime;
    SDK_SYSTEM_TIME endTime;
    //下面是播放一整天的云视频，也可以根据想要播放的云视频录像段，自己设置开始和结束时间
    beginTime.year = [NSDate getYearFormDate:date];
    beginTime.month = [NSDate getMonthFormDate:date];
    beginTime.day = [NSDate getDayFormDate:date];
    beginTime.hour = [NSDate getHourFormDate:date];
    beginTime.minute = [NSDate getMinuteFormDate:date];
    beginTime.second = [NSDate getSecondFormDate:date];
    
    endTime.year = [NSDate getYearFormDate:date];
    endTime.month = [NSDate getMonthFormDate:date];
    endTime.day = [NSDate getDayFormDate:date];
    endTime.hour = 23;
    endTime.minute = 59;
    endTime.second = 59;
    
    time_t ToTime_t(SDK_SYSTEM_TIME *time);
    int beginTimeInt = (int)ToTime_t(&beginTime);
    
    time_t ToTime_t(SDK_SYSTEM_TIME *time);
    int endTimeInt = (int)ToTime_t(&endTime);
    
    self.player = FUN_MediaCloudRecordPlay(self.msgHandle, SZSTR(self.devID),self.channel, "", beginTimeInt, endTimeInt, (__bridge LP_WND_OBJ)self.renderWnd);
}
#pragma mark - 停止
-(int)stop{
    
    return [super stop];
}

#pragma mark - 暂停
-(int)pause{
    return [super pause];
}

#pragma mark - 恢复
-(int)resumue{
    return [super resumue];
}
#pragma mark -  清除当前界面图像
-(void)refresh
{
    FUN_MediaRefresh(self.msgHandle);
}

#pragma mark - 开始智能快放
-(int)setIntelPlay
{
    return Fun_MediaSetIntellPlay(self.player,  ((1 << EMSSubType_INVASION | 1 << EMSSubType_STRANDED) & 0x3FFFFFF), 8);
}
#pragma mark - 停止智能快放
-(int)stopIntelPlay
{
    return Fun_MediaSetIntellPlay(self.player,  ((1 << EMSSubType_INVASION | 1 << EMSSubType_STRANDED) & 0x3FFFFFF), 0);
}
#pragma mark - 拖动时间轴切换播放时间
-(void)seekToTime:(NSInteger)addtime
{
    FUN_MediaSeekToTime(self.player, (int)addtime, 0, 0);
}

#pragma mark - 设置播放速度(可设置1倍、2倍 、4倍，对应speed为0、1、2)
-(void)setPlaySpeed:(int)speed
{
    FUN_MediaSetPlaySpeed(self.player, speed, 0);
}

#pragma mark FunSDK 结果
-(void)OnFunSDKResult:(NSNumber *)pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    [super OnFunSDKResult:pParam];
    switch ( msg->id ) {
#pragma mark 设置播放速度
        case EMSG_SET_PLAY_SPEED:{
            if(self.playbackDelegate && [self.playbackDelegate respondsToSelector:@selector(setPlaySpeedResult:)])
            {
                [self.playbackDelegate setPlaySpeedResult:msg->param1];
            }
        }
            break;
        default:
            break;
    }
}

@end
