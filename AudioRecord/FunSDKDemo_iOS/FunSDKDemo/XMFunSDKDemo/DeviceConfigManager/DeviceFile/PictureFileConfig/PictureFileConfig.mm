//
//  PictureFileConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/16.
//  Copyright © 2018年 XM. All rights reserved.
//
#define MAX_FINDFILE_SIZE        10000    //每次搜索的最大文件数量,可以根据需要自行设置
#import "PictureFileConfig.h"
#import "OPSCalendar.h"
#import "FunSDK/FunSDK.h"

@interface PictureFileConfig ()
{
    OPSCalendar canendar; //查询一个月内哪些天有图片
    NSMutableArray *fileArray;  //按文件搜索某一天的录像数组结果
    NSMutableArray *dateArray; //搜索某一个月哪些天有图片的结果数组
}
@end
@implementation PictureFileConfig

#pragma mark - 搜索传入这一天的设备图片
- (void)getDevicePictureByFile:(NSDate*)date {
    fileArray = [[NSMutableArray alloc] initWithCapacity:0];
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    //开内存
    H264_DVR_FINDINFO info;
    memset(&info, 0, sizeof(info));
    info.nChannelN0 = channel.channelNumber;
    info.nFileType  = SDK_PIC_ALL; //查询全部类型的图片
    //开始时间
    info.startTime.dwYear = (int)[components year];
    info.startTime.dwMonth = (int)[components month];
    info.startTime.dwDay = (int)[components day];
    info.startTime.dwHour = 0; //小时、分钟、秒可以根据需要进行修改
    info.startTime.dwMinute = 0;
    info.startTime.dwSecond = 0;
    //结束时间
    info.endTime.dwYear   = (int)[components year];
    info.endTime.dwMonth  = (int)[components month];
    info.endTime.dwDay    = (int)[components day];
    info.endTime.dwHour   = 23;
    info.endTime.dwMinute = 59;
    info.endTime.dwSecond = 59;
    //开始搜索设备图片
    FUN_DevFindFile(self.MsgHandle, SZSTR(channel.deviceMac), &info, MAX_FINDFILE_SIZE);
}

#pragma mark - 获取一个月内有图片的日期
- (void)getMonthPictureDate:(NSDate *)date {
    dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSString * cmd = [NSString stringWithFormat:@"{\"Name\":\"OPSCalendar\",\"OPSCalendar\": {\"Event\":   \"*\",\"FileType\": \"jpg\",\"Month\":  %ld ,\"Rev\":   \"\",\"Year\": %ld},\"SessionID\":   \"0x00000001\"}",(long)[components month],(long)[components year]];
    FUN_DevCmdGeneral(self.MsgHandle,SZSTR(channel.deviceMac),1446, "OPSCalendar",0, 5000,strdup(SZSTR(cmd)));
    
    //解析配置用到的对象初始化
    CfgParam* calendarCfg = [[CfgParam alloc] initWithName:NSSTR(canendar.Name()) andDevId:channel.deviceMac andChannel:channel.channelNumber andConfig:&canendar andOnce:YES andSaveLocal:YES];
    [self AddCmdfig:calendarCfg];
}

#pragma mark - 读取各种请求的结果
- (NSMutableArray *)getPictureFileArray { //获取请求到的图片数组
    return [fileArray mutableCopy];
}
- (NSMutableArray *)getMonthPictureArray { //获取设备一个月内哪些天有图片的数组
    int mask = canendar.Mask.Value();
    for( int i=0; i < 32; i++ ){
        //判断一个月31天内，哪一天有录像，31位二进制，等于一的日期有录像
        if ((mask & (1<<i)) && mask>0) {
            NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
            NSString* strDate = [NSString stringWithFormat:@"%04ld-%02ld-%02d",components.year, components.month, i+1];
            [dateArray addObject:strDate];
        }
    }
    return dateArray;
}

#pragma  mark - 获取设备图片回调
-(void)OnGetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:NSSTR(canendar.Name())]) {
        NSLog(@"Mask = %d",canendar.Mask.Value());
        if ([self.delegate respondsToSelector:@selector(getPictureResult:)]) {
            [self.delegate getPictureResult:param.errorCode];
        }
    }
};
#pragma mark - 请求图片结果回调信息
-(void)OnFunSDKResult:(NSNumber *) pParam{
    [super OnFunSDKResult:pParam];
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch (msg->id) {
        #pragma mark 图片查询结果回调
        case EMSG_DEV_FIND_FILE: {
            if (msg->param1 < 0) {
                [MessageUI ShowErrorInt:msg->param1];
            }else{
                [SVProgressHUD dismiss];
                int num = msg->param1;
                H264_DVR_FILE_DATA *pFile = (H264_DVR_FILE_DATA *)msg->pObject;
                for (int i=0; i<num; i++) {
                    PictureInfo *pictureInfo = [PictureInfo new];
                    pictureInfo.channelNo   = pFile[i].ch;
                    pictureInfo.fileType    = 0; //文件类型是文件名中 中括号中的大写字母表示，例如：[M] 移动侦测,[H]手动录像，[*]普通录像等等
                    pictureInfo.fileName    = [NSString stringWithUTF8String:pFile[i].sFileName];
                    pictureInfo.fileSize    = pFile[i].size;
                    XM_SYSTEM_TIME timeBegin;
                    memcpy(&timeBegin, (char*)&(pFile[i].stBeginTime), sizeof(SDK_SYSTEM_TIME));
                    pictureInfo.timeBegin = timeBegin;
                    XM_SYSTEM_TIME timeEnd;
                    memcpy(&timeEnd, (char*)&(pFile[i].stEndTime), sizeof(SDK_SYSTEM_TIME));
                    pictureInfo.timeEnd = timeEnd;
                    [fileArray addObject:pictureInfo];
                }
            }
            if ([self.delegate respondsToSelector:@selector(getPictureResult:)]) {
                [self.delegate getPictureResult:msg->param1];
            }
        }
            break;
        case EMSG_DEV_CMD_EN: {
        }
            break;
        default:
            break;
    }
}
@end
