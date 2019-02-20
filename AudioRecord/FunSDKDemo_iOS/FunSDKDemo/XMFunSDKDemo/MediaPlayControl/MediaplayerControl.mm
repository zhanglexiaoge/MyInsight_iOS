//
//  MediaplayerControl.m
//  FunSDKDemo
//
//  Created by XM on 2018/10/17.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "MediaplayerControl.h"

@implementation MediaplayerControl

#pragma mark - 开启视频
-(int)start{
    
    if ( self.status != MediaPlayerStatusStop)  {
        [self stop];
    }
    if(self.status == MediaPlayerStatusStop){
        self.player = FUN_MediaRealPlay(self.msgHandle, [self.devID UTF8String], self.channel, self.stream, (__bridge LP_WND_OBJ)self.renderWnd, 0);
    }
    return self.player;
}
#pragma mark - 停止
-(int)stop{
    self.status = MediaPlayerStatusStop;
    return FUN_MediaStop(self.player, 0);
}

#pragma mark - 暂停
-(int)pause{
    int nRet = -1;
    if ( self.status == MediaPlayerStatusPlaying ) {
        nRet = FUN_MediaPause(self.player, 1, 0);
        self.status = MediaPlayerStatusPause;
    }
    return nRet;
}
#pragma mark - 恢复
-(int)resumue{
    if ( self.status != MediaPlayerStatusPause ) {
        return -1;
    }
    self.status = MediaPlayerStatusPlaying;
    return FUN_MediaPause(self.player, 0);
}

#pragma mark - 打开音频，传递音频大小，0-100
-(int)openSound:(int)soundValue{
    return FUN_MediaSetSound(self.player, soundValue, 0);
}
#pragma mark - 关闭音频
-(int)closeSound{
    return FUN_MediaSetSound(self.player, 0, 0);
}

#pragma mark - 抓图
-(int)snapImage{
    NSString *dateString = [NSString GetSystemTimeString];
    NSString *file = [NSString getPhotoPath];
    NSString *pictureFilePath = [file stringByAppendingFormat:@"/%@.jpg",dateString];
    return FUN_MediaSnapImage(self.player, [pictureFilePath UTF8String]);
}

#pragma mark - 开始录像
-(int)startRecord{
    NSString *dateString = [NSString GetSystemTimeString];
    NSString *file = [NSString getVideoPath];
    if (self.IsYuv == YES) {
        //鱼眼设备录像
        NSString *movieFilePath = [file stringByAppendingFormat:@"/%@.fvideo",dateString];
        return FUN_MediaStartRecord(self.player, [movieFilePath UTF8String]);
    }else{
        //普通设备录像
        NSString *movieFilePath = [file stringByAppendingFormat:@"/%@.mp4",dateString];
         return FUN_MediaStartRecord(self.player, [movieFilePath UTF8String]);
    }
}

#pragma mark - 停止录像
-(int)stopRecord{
    return FUN_MediaStopRecord(self.player);
}

#pragma mark - 切换清晰度
-(void)changeStream:(int)stream{
    if (stream == -1) {
        self.stream = !self.stream;
    }else{
        self.stream = stream;
    }
    //切换码流先停止再播放
    [self stop];
    [self start];
}

#pragma mark - 点击云台控制的按钮，开始控制  这个接口没有回调信息
-(void)controZStartlPTAction:(PTZ_ControlType)sender {
    FUN_DevPTZControl(self.msgHandle, SZSTR(self.devID), self.channel, sender, false, 4);
}
#pragma mark - 抬起云台控制的按钮，结束控制   这个接口没有回调信息
-(void)controZStopIPTAction:(PTZ_ControlType)sender {
    FUN_DevPTZControl(self.msgHandle, SZSTR(self.devID), self.channel, sender, true, 4);
}
#pragma mark - 设置播放速度
-(void)setPlaySpeed:(int)speed
{
    FUN_MediaSetPlaySpeed(self.player, speed, 0);
}

#pragma mark FunSDK 结果
-(void)OnFunSDKResult:(NSNumber *)pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    
    switch ( msg->id ) {
#pragma mark 收到开始直播结果消息
        case EMSG_START_PLAY:{
            if (msg->param1==0) {
                self.status = MediaPlayerStatusBuffering;
                NSLog(@"播放成功～～");
            }else{
                self.status = MediaPlayerStatusStop;
                NSLog(@"播放失败～～");
            }
            if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:startResult:DSSResult:)] ) {
                [self.delegate mediaPlayer:self startResult:msg->param1 DSSResult:msg->param3];
            }
        }
            break;
#pragma mark 收到暂停播放结果消息
        case EMSG_PAUSE_PLAY:{
            if (msg->param1==2) {
                //2为暂停
                self.status = MediaPlayerStatusPause;
            }else if (msg->param1 == 1){
                //1为恢复
                self.status = MediaPlayerStatusPlaying;
            }
            if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:pauseOrResumeResult:)] ) {
                [self.delegate mediaPlayer:self pauseOrResumeResult:msg->param1];
            }
        }
            break;
#pragma mark 收到开始缓存数据结果消息
        case EMSG_ON_PLAY_BUFFER_BEGIN:{
            if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:buffering:)] ) {
                [self.delegate mediaPlayer:self buffering:YES];
            }
        }
            break;
#pragma mark 收到缓冲结束开始有画面结果消息
        case EMSG_ON_PLAY_BUFFER_END:{
            if (msg->param1==0) {
                self.status = MediaPlayerStatusPlaying;
            }
            if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:buffering:)] ) {
                [self.delegate mediaPlayer:self buffering:NO];
            }
        }
            break;
#pragma mark  媒体通道网络异常断开
        case EMSG_ON_MEDIA_NET_DISCONNECT:{
            if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:startResult:DSSResult:)] ) {
                [self.delegate mediaPlayer:self startResult:EE_DVR_SUB_CONNECT_ERROR DSSResult:msg->param3];
            }
        }
            break;
#pragma mark 收到抓图回调结果消息
        case EMSG_SAVE_IMAGE_FILE:{
            if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:snapImagePath:result:)] ) {
                [self.delegate mediaPlayer:self snapImagePath:NSSTR(msg->szStr) result:msg->param1];
            }
        }
            break;
#pragma mark 收到查询直播信息结果消息
        case EMSG_ON_PLAY_INFO:{
            if (msg->param1 <0) {
                //缓冲结束之后播放失败
                if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:startResult:DSSResult:)] ) {
                    [self.delegate mediaPlayer:self startResult:msg->param1 DSSResult:msg->param3];
                }
                break;
            }
            const char *time=msg->szStr;
            NSString *str = [NSString stringWithUTF8String:time];
            NSString *devtime;
            if (str.length >18) {
                devtime = [str substringToIndex:19];
            }
            if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:info1:info2:)] ) {
                //播放信息
                [self.delegate mediaPlayer:self info1:msg->param1 info2:NSSTR(msg->szStr)];
            }
            if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:DevTime:)] ) {
                //设备时间
                [self.delegate mediaPlayer:self DevTime:devtime];
            }
            if ([self.delegate respondsToSelector:@selector(mediaPlayer:timeInfo:)]) {
                //回放时间
                [self.delegate mediaPlayer:self timeInfo:msg->param2];
            }
        }
            break;
#pragma mark 收到开始录像结果消息
        case EMSG_START_SAVE_MEDIA_FILE:{
            if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:startRecordResult:path:)] ) {
                [self.delegate mediaPlayer:self startRecordResult:msg->param1 path:[NSString stringWithUTF8String:msg->szStr]];
            }
        }
            break;
#pragma mark 收到停止录像结果消息
        case EMSG_STOP_SAVE_MEDIA_FILE:{
            if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:stopRecordResult:path:)] ) {
                [self.delegate mediaPlayer:self stopRecordResult:msg->param1 path:[NSString stringWithUTF8String:msg->szStr]];
            }
        }
            break;
#pragma mark 停止播放
        case EMSG_STOP_PLAY:{
            if ([self.delegate respondsToSelector:@selector(mediaPlayer:stopResult:)]) {
                [self.delegate mediaPlayer:self stopResult:msg->param1];
            }
        }
            break;
#pragma mark 刷新播放
        case EMSG_REFRESH_PLAY:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:refreshPlayResult:)]) {
                [self.delegate mediaPlayer:self refreshPlayResult:msg->param1];
            }
        }
            break;
#pragma mark -鱼眼相关处理
#pragma mark 用户自定义信息帧回调
        case EMSG_ON_FRAME_USR_DATA:{
            int Hardandsoft = 0;//软解
            int Hardmodel = 0 ;
            
            if (msg->param2 == 3 ) {
                SDK_FishEyeFrameHW fishFrame = {0};
                memcpy(&fishFrame, msg->pObject + 8, sizeof(SDK_FishEyeFrameHW));
                if (fishFrame.secene == SDK_FISHEYE_SECENE_P360_FE) {
                    Hardandsoft = 3;
                    Hardmodel = SDK_FISHEYE_SECENE_P360_FE;
                    
                    FUN_SetIntAttr(self.player, EOA_MEDIA_YUV_USER, self.msgHandle);//返回Yuv数据
                    FUN_SetIntAttr(self.player, EOA_SET_MEDIA_VIEW_VISUAL, 0);//自己画画面
                    self.IsYuv = YES;
                    
                }else if (fishFrame.secene == SDK_FISHEYE_SECENE_RRRR_R) {
                    Hardandsoft = 3;
                    Hardmodel = SDK_FISHEYE_SECENE_RRRR_R;
                    
                    FUN_SetIntAttr(self.player, EOA_MEDIA_YUV_USER, 0);//不返回Yuv数据
                    FUN_SetIntAttr(self.player, EOA_SET_MEDIA_VIEW_VISUAL, 1);//底层画画面
                    self.IsYuv = NO;
                }
            }
            else if((msg->param2 == 4) && \
                    (msg->param1 >= (8 + sizeof(SDK_FishEyeFrameSW)))) {
                SDK_FishEyeFrameSW fishFrame = {0};
                Hardandsoft =4;
                memcpy(&fishFrame, msg->pObject + 8, sizeof(SDK_FishEyeFrameSW));
                
                FUN_SetIntAttr(self.player, EOA_MEDIA_YUV_USER, self.msgHandle);//返回Yuv数据
                FUN_SetIntAttr(self.player, EOA_SET_MEDIA_VIEW_VISUAL, 0);//自己画画面
                self.IsYuv = YES;
                
                // 圆心偏差横坐标  单位:像素点
                short  centerOffsetX = fishFrame.centerOffsetX;
                //圆心偏差纵坐标  单位:像素点
                short centerOffsetY = fishFrame.centerOffsetY;
                //半径  单位:像素点
                short radius = fishFrame.radius;
                //圆心校正时的图像宽度  单位:像素点
                short imageWidth = fishFrame.imageWidth;
                //圆心校正时的图像高度  单位:像素点
                short imageHeight = fishFrame.imageHeight;
                //视角  0:俯视   1:平视
                if (fishFrame.viewAngle == 0) {
                    
                }
                //显示模式   0:360VR
                if (fishFrame.lensType == SDK_FISHEYE_LENS_360VR || fishFrame.lensType == SDK_FISHEYE_LENS_360LVR) {//360vr
                    Hardmodel =0;
                }else{//180Vr
                    Hardmodel = 1;
                    
                }
                if ( self.delegate && [self.delegate respondsToSelector:@selector(centerOffSetX:offSetx:offY:radius:width:height:)] ) {
                    [self.delegate centerOffSetX:self offSetx:centerOffsetX offY:centerOffsetY radius:radius width:imageWidth height:imageHeight];
                }
            }
            else if (msg->param2 == 5)
            {
                //如果是已经保存过信息不支持的设备，则不进行YUV
                NSString *correct;// = [Config getCorrectdev:_devID];
                if ([correct isEqualToString:@"0"]) {
                    
                }else{
                    Hardandsoft = 5;
                    FUN_SetIntAttr(self.player, EOA_MEDIA_YUV_USER, self.msgHandle);//返回Yuv数据
                    FUN_SetIntAttr(self.player, EOA_SET_MEDIA_VIEW_VISUAL, 0);//自己画画面
                }
            }
            else if (msg->param2 == 8)
            {
                if ([self.delegate respondsToSelector:@selector(mediaPlayer:AnalyzelLength:site:Analyzel:)]) {
                    [self.delegate mediaPlayer:self AnalyzelLength:msg->param1 site:msg->param3 Analyzel:msg->pObject];
                }
                //如果是智能分析报警坐标信息，则调用代理之后直接return
                return;
            }
            if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:Hardandsoft:Hardmodel:)] ) {
                [self.delegate mediaPlayer:self Hardandsoft:Hardandsoft Hardmodel:Hardmodel];
            }
            ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
            channel.isFish = self.IsYuv;
        }
            break;
#pragma mark YUV数据回调
        case EMSG_ON_YUV_DATA:{
            if ( self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:width:height:pYUV:)] ) {
                [self.delegate mediaPlayer:self width:msg->param2 height:msg->param3 pYUV:(unsigned char *)msg->pObject];
            }
        }
            break;
        default:
            break;
    }
}

@end
