//
//  VideoFileConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/13.
//  Copyright © 2018年 XM. All rights reserved.
//
#define MAX_FINDFILE_SIZE        10000    //每次搜索的最大文件数量,可以根据需要自行设置
#import "FunSDK/FunSDK.h"
#import "VideoFileConfig.h"
#import "OPSCalendar.h"
@interface VideoFileConfig  ()
{
    OPSCalendar canendar; //查询一个月内哪些天有录像
    NSMutableArray *fileArray;  //按文件搜索某一天的录像数组结果
    NSMutableArray *timeArray; //按时间搜索某一天的录像数组结果
    NSMutableArray *dateArray; //搜索某一个月哪些天有录像的结果数组
}
@end
@implementation VideoFileConfig

#pragma mark - 按文件搜索设备传入这一天的录像
- (void)getDeviceVideoByFile:(NSDate*)date{
    fileArray = [[NSMutableArray alloc] initWithCapacity:0];
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    //开内存
    H264_DVR_FINDINFO info;
    memset(&info, 0, sizeof(info));
    info.nChannelN0 = channel.channelNumber;
    info.nFileType  = SDK_RECORD_ALL; //查询全部类型的录像
    //开始时间
    info.startTime.dwYear = (int)[components year];
    info.startTime.dwMonth = (int)[components month];
    info.startTime.dwDay = (int)[components day];
    info.startTime.dwHour = 0;
    info.startTime.dwMinute = 0;
    info.startTime.dwSecond = 0;
    //结束时间
    info.endTime.dwYear   = (int)[components year];
    info.endTime.dwMonth  = (int)[components month];
    info.endTime.dwDay    = (int)[components day];
    info.endTime.dwHour   = 23;
    info.endTime.dwMinute = 59;
    info.endTime.dwSecond = 59;
    //开始搜索设备录像
    FUN_DevFindFile(self.MsgHandle, SZSTR(channel.deviceMac), &info, MAX_FINDFILE_SIZE);
}

#pragma mark - 按时间搜索传入这一天的设备录像
- (void)getDeviceVideoByTime:(NSDate*)date {
    timeArray = [[NSMutableArray alloc] initWithCapacity:0];
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //开内存
    SDK_SearchByTime info;
    memset(&info, 0, sizeof(info));
    info.nHighChannel = 0;
    info.nLowChannel  = 0;
    info.nFileType  = 0;
    info.iSync  = 0;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    //搜索录像的开始时间
    SDK_SYSTEM_TIME stBeginTime;
    memset(&stBeginTime, 0, sizeof(stBeginTime));
    stBeginTime.year = (int)[components year];
    stBeginTime.month = (int)[components month];
    stBeginTime.day = (int)[components day];
    //具体开始时间可以根据需要自己设置
    stBeginTime.hour = 0;
    stBeginTime.minute = 0;
    stBeginTime.second = 0;
    info.stBeginTime = stBeginTime;
    
    //搜索录像的结束时间
    SDK_SYSTEM_TIME stEndTime = {0};
    stEndTime.year = (int)[components year];
    stEndTime.month = (int)[components month];
    stEndTime.day = (int)[components day];
    //具体结束时间可以根据需要自己设置，结束时间必须要比开始时间晚
    stEndTime.hour = 23;
    stEndTime.minute = 59;
    stEndTime.second = 59;
    info.stEndTime = stEndTime;
    
    int chn = channel.channelNumber;
    if (chn > 31){
        info.nHighChannel = (1 << (chn - 32));
    }else{
        info.nLowChannel = (1 << chn);
    }
    //开始按时间搜索录像
    FUN_DevFindFileByTime(self.MsgHandle, SZSTR(channel.deviceMac), &info);
}

#pragma mark - 获取一个月内有录像的日期
- (void)getMonthVideoDate:(NSDate *)date {
    dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSString * cmd = [NSString stringWithFormat:@"{\"Name\":\"OPSCalendar\",\"OPSCalendar\": {\"Event\":   \"*\",\"FileType\": \"h264\",\"Month\":  %ld ,\"Rev\":   \"\",\"Year\": %ld},\"SessionID\":   \"0x00000001\"}",(long)[components month],(long)[components year]];
    FUN_DevCmdGeneral(self.MsgHandle,SZSTR(channel.deviceMac),1446, "OPSCalendar",0, 5000,strdup(SZSTR(cmd)));
    
    //解析配置用到的对象初始化
    CfgParam* calendarCfg = [[CfgParam alloc] initWithName:NSSTR(canendar.Name()) andDevId:channel.deviceMac andChannel:channel.channelNumber andConfig:&canendar andOnce:YES andSaveLocal:YES];
    [self AddCmdfig:calendarCfg];
}

#pragma mark - 读取各种请求录像信息的结果
- (NSMutableArray *)getVideoFileArray { //获取按文件请求到的录像数组
    return [fileArray mutableCopy];
}
- (NSMutableArray *)getVideoTimeArray { //获取按时间请求到的录像数组
    return [timeArray mutableCopy];
}
- (NSMutableArray *)getMonthVideoArray { //获取设备一个月内哪些天有录像的数组
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
#pragma  mark - 获取摄像机录像回调
-(void)OnGetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:NSSTR(canendar.Name())]) {
        NSLog(@"Mask = %d",canendar.Mask.Value());
        if ([self.delegate respondsToSelector:@selector(getVideoResult:)]) {
            [self.delegate getVideoResult:param.errorCode];
        }
    }
};
#pragma mark - 请求录像结果回调信息
-(void)OnFunSDKResult:(NSNumber *) pParam{
    [super OnFunSDKResult:pParam];
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch (msg->id) {
        #pragma mark  录像按文件查询查询回调
        case EMSG_DEV_FIND_FILE: {        // 录像按文件查询查询回调
            if (msg->param1 < 0) {
                [MessageUI ShowErrorInt:msg->param1];
            }else{
                [SVProgressHUD dismiss];
                int num = msg->param1;
                H264_DVR_FILE_DATA *pFile = (H264_DVR_FILE_DATA *)msg->pObject;

                for (int i=0; i<num; i++) {
                    RecordInfo *recordInfo = [RecordInfo new];
                    recordInfo.channelNo   = pFile[i].ch;
                    recordInfo.fileType    = 0; //文件类型是文件名中 中括号中的大写字母表示，例如：[M] 移动侦测,[H]手动录像，[*]普通录像等等。可以参考 SDK_RECORD_ALL 的子类型
                    recordInfo.fileName    = [NSString stringWithUTF8String:pFile[i].sFileName];
                    recordInfo.fileSize    = pFile[i].size;
                    XM_SYSTEM_TIME timeBegin;
                    memcpy(&timeBegin, (char*)&(pFile[i].stBeginTime), sizeof(SDK_SYSTEM_TIME));
                    recordInfo.timeBegin = timeBegin;
                    XM_SYSTEM_TIME timeEnd;
                    memcpy(&timeEnd, (char*)&(pFile[i].stEndTime), sizeof(SDK_SYSTEM_TIME));
                    recordInfo.timeEnd = timeEnd;
                    [fileArray addObject:recordInfo];
                }
            }
  
            if ([self.delegate respondsToSelector:@selector(getVideoResult:)]) {
                [self.delegate getVideoResult:msg->param1];
            }
        }
            break;
    #pragma mark 按时间搜索录像文件
        case EMSG_DEV_FIND_FILE_BY_TIME: { //按时间搜索录像文件
            //成功查询
            [SVProgressHUD dismiss];
            NSInteger addCount = 0;
            NSInteger _add = 0;
            if (msg->param1 < 0) {
                [MessageUI ShowErrorInt:msg->param1]; //没有查询到文件
            }else {
                //获取通道
                SDK_SearchByTimeResult *pResult = (SDK_SearchByTimeResult *)msg->pObject;
                SDK_SearchByTimeInfo *backData = &pResult->ByTimeInfo[0];
                
                //按时间搜索，返回的信息是720份，每份包含两分钟时长，其中包含是否有录像，录像类型，录像开始结束时间等等信息
                for (int i = 0; i < 720; i ++) {
                    //每两分钟分割成两份，每份一分钟，这样一共1440份，每份TimeInfo代表一分钟
                    ByteRecordType *pType = (ByteRecordType *)(&backData->cRecordBitMap[i]);
                    if (pType->t0 != 0 && pType->t1 != 0) {
                        _add = i * 60 / 2;
                        addCount = addCount + 1;
                    }
                    [self createVideoDataWithType:[self getType:pType->t0] andStartTime:(i*120) andEndTime:((i*120) + 60) toArray:timeArray];
                    [self createVideoDataWithType:[self getType:pType->t1] andStartTime:((i*120) + 60) andEndTime:(i + 1)*120 toArray:timeArray];
                }
            }
            if (addCount == 0) {
                [SVProgressHUD showErrorWithStatus:TS("无录像")];
                return;
            }
            if ([self.delegate respondsToSelector:@selector(addTimeDelegate:)]) {
                [self.delegate addTimeDelegate:_add];
            }
            if ([self.delegate respondsToSelector:@selector(getVideoResult:)]) {
                [self.delegate getVideoResult:msg->param1];
            }
        }
            break;
        default:
            break;
    }
}
//存储到 _array_Video数组中
-(void)createVideoDataWithType:(enum Video_Type)type andStartTime:(int)ss  andEndTime:(int)es toArray:(NSMutableArray *)array {
    //开辟内存
    TimeInfo *info = [[TimeInfo alloc] init];
    info.type = type;
    info.start_Time = ss;
    info.end_Time = es;
    [array addObject:info];
}
//读取录像类型
-(Video_Type)getType:(int)sdkType{
    switch(sdkType) {
        case 0:
            return TYPE_NONE;
        case 1:
            return TYPE_NORMAL;
        case 2:
            return TYPE_ALARM;
        case 3:
            return TYPE_DETECTION;
        case 4:
            return TYPE_NORMAL;
        case 5:
            return TYPE_HAND;
        default:
            return TYPE_NORMAL;
            break;
    }
    return TYPE_NORMAL;
}
@end
