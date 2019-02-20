//
//  VideoFileDownloadConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/15.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "VideoFileDownloadConfig.h"

@implementation VideoFileDownloadConfig

#pragma mark - 开始下载录像
- (void)downloadFile:(RecordInfo*)record {
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //初始化请求结构体
    H264_DVR_FILE_DATA info;
    memset(&info, 0, sizeof(info));
    info.size  = (int)record.fileSize;
    //开始时间
    XM_SYSTEM_TIME timeBegin = record.timeBegin;
    memcpy(&info.stBeginTime,  (char *)&timeBegin, sizeof(SDK_SYSTEM_TIME));
    //结束时间
    XM_SYSTEM_TIME timeEnd = record.timeEnd;
    memcpy(&info.stEndTime, (char*)&timeEnd,sizeof(SDK_SYSTEM_TIME));
    //通道号
    strncpy(info.sFileName, [record.fileName UTF8String], sizeof(info.sFileName));
    info.ch = (int)record.channelNo;
    //存储路径
    NSString *directoryPath = [NSString getVideoPath];
    NSString *timeString = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",timeBegin.year,timeBegin.month,timeBegin.day,timeBegin.hour,timeBegin.minute,timeBegin.second];
    //后缀   如果是鱼眼设备，需要特殊保存，然后用鱼眼播放器进行播放，参考鱼眼视频剪切和本地播放
    //    if (self.isFish) {
    //        movieFilePath = [directoryPath stringByAppendingFormat:@"/%@.fvideo",timeString];
    //    }
    NSString *movieFilePath  = [directoryPath stringByAppendingFormat:@"/%@.mp4",timeString];
    //开始下载
    FUN_DevDowonLoadByFile(self.msgHandle, SZSTR(channel.deviceMac), &info, SZSTR(movieFilePath));
}

#pragma mark - SDK回调
-(void)OnFunSDKResult:(NSNumber *) pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch (msg->id) {
            #pragma mark 开始下载录像回调
        case EMSG_ON_FILE_DOWNLOAD: {// 开始下载
            if ([self.delegate respondsToSelector:@selector(fileDownloadStartResult:)]) {
                [self.delegate fileDownloadStartResult:msg->param1];
            }
        }
            break;
        #pragma mark 录像下载的进度
        case EMSG_ON_FILE_DLD_POS:  {//下载的进度
            if ([self.delegate respondsToSelector:@selector(fileDownloadProgressResult:)]) {
                if (msg->param1 > 0 && msg->param2 >0) {
                    [self.delegate fileDownloadProgressResult:(CGFloat)msg->param2 / (CGFloat)msg->param1];
                }
            }
        }
            break;
         #pragma mark 录像下载完成
        case EMSG_ON_FILE_DLD_COMPLETE: { //下载完成
            if ([self.delegate respondsToSelector:@selector(fileDownloadEndResult)]) {
                [self.delegate fileDownloadEndResult];
                NSLog(@"录像下载成功：%s",msg->szStr);
            }
        }
            break;
    }
}
@end
