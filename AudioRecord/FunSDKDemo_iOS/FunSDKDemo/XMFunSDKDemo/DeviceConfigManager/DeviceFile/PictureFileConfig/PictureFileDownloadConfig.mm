//
//  PictureFileDownloadConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/16.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "PictureFileDownloadConfig.h"

@implementation PictureFileDownloadConfig

#pragma mark - 根据传入的图片信息开始下载小缩略图片
- (void)downloadSmallPicture:(PictureInfo*)pictureInfo{
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //存储路径
    NSString *directoryPath = [NSString thumbnailPath];
    //开始时间
    XM_SYSTEM_TIME timeBegin = pictureInfo.timeBegin;
    NSString *timeString = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",timeBegin.year,timeBegin.month,timeBegin.day,timeBegin.hour,timeBegin.minute,timeBegin.second];
    NSString *thumbPath  = [directoryPath stringByAppendingFormat:@"/%@.jpg",timeString];
    
    char pInparm[512] = {0};
    sprintf(pInparm, "{\"Name\" : \"OPCompressPic\", \"OPCompressPic\": {\"Width\" : 160,\"Height\" :100,  \"IsGeo\" :1, \"PicName\" :\"%s\"},\"SessionID\" : \"0x00000002\"}",SZSTR(pictureInfo.fileName));
    FUN_DevSearchPic(self.msgHandle, SZSTR(channel.deviceMac), 1448, 30000, 2000, pInparm, (int)strlen(pInparm), 10,  -1,  SZSTR(thumbPath), 0);
}

#pragma mark - 根据传入的图片信息下载图片
- (void)downloadPicture:(PictureInfo*)pictureInfo {
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //下载原图
    H264_DVR_FILE_DATA fileData = {0};
    fileData.ch = (int)pictureInfo.channelNo;
    fileData.size = (int)pictureInfo.fileSize;
    strncpy(fileData.sFileName, SZSTR(pictureInfo.fileName), 108);
    //开始时间
    XM_SYSTEM_TIME timeBegin = pictureInfo.timeBegin;
    fileData.stBeginTime.year = (int)timeBegin.year;
    fileData.stBeginTime.month = (int)timeBegin.month;
    fileData.stBeginTime.day = (int)timeBegin.day;
    fileData.stBeginTime.hour = ((int)timeBegin.hour);
    fileData.stBeginTime.minute = (int)timeBegin.minute;
    fileData.stBeginTime.second = (int)timeBegin.second;
    //结束时间
    XM_SYSTEM_TIME timeEnd = pictureInfo.timeEnd;
    fileData.stEndTime.year = (int)timeEnd.year;
    fileData.stEndTime.month = (int)timeEnd.month;
    fileData.stEndTime.day = (int)timeEnd.day;
    fileData.stEndTime.hour = ((int)timeEnd.hour);
    fileData.stEndTime.minute = (int)timeEnd.minute;
    fileData.stEndTime.second = (int)timeEnd.second;
    //下载路径
    NSString *directoryPath = [NSString getPhotoPath];
    NSString *timeString = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",timeBegin.year,timeBegin.month,timeBegin.day,timeBegin.hour,timeBegin.minute,timeBegin.second];
     NSString *pictureFilePath  = [directoryPath stringByAppendingFormat:@"/%@.jpg",timeString];
    //开始下载
    FUN_DevDowonLoadByFile(self.msgHandle, SZSTR(channel.deviceMac), &fileData, SZSTR(pictureFilePath), 0);
}

#pragma mark - SDK回调
-(void)OnFunSDKResult:(NSNumber *) pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    NSLog(@"msg->id = %d",msg->id);
    switch (msg->id) {
        #pragma mark  缩略图下载成功回调
        case EMSG_DEV_SEARCH_PIC:{
            if ( [self.delegate respondsToSelector:@selector(thumbDownloadResult: path:)]) {
                 [self.delegate thumbDownloadResult:msg->param1 path:NSSTR(msg->szStr)];
            }
        }
            break;
        #pragma mark  原图开始下载回调
        case EMSG_ON_FILE_DOWNLOAD:{ //原图开始下载回调
            if ([self.delegate respondsToSelector:@selector(pictureDownloadStartResult:)]) {
                [self.delegate pictureDownloadStartResult:msg->param1];
            }
        }
            break;
        #pragma mark 原图下载进度回调
        case EMSG_ON_FILE_DLD_POS:{ //原图下载进度
            if ([self.delegate respondsToSelector:@selector(pictureDownloadProgressResult:)]) {
                if (msg->param1 < 0) {
                }else {
                    [self.delegate pictureDownloadProgressResult:(CGFloat)msg->param2 / (CGFloat)msg->param1];
                }
            }
        }
            break;
        #pragma mark  原图下载成功回调
        case EMSG_ON_FILE_DLD_COMPLETE: { //原图下载成功
            if ([self.delegate respondsToSelector:@selector(pictureDownloadEndResultPath:)]) {
                [self.delegate pictureDownloadEndResultPath:NSSTR(msg->szStr)];
            }
        }
    }
}
@end
