//
//  CloudVideoConfig.m
//  FunSDKDemo
//
//  Created by XM on 2019/1/7.
//  Copyright © 2019年 XM. All rights reserved.
//

#import "CloudVideoConfig.h"
#import "FunSDK/FunSDK.h"
#import "FunSDK/Fun_CM.h"
#import "TimeInfo.h"

@interface CloudVideoConfig ()
{
    NSMutableArray *fileArray;  //搜索某一天的云视频数组结果
    NSMutableArray *dateArray; //搜索某一个月哪些天有云视频的结果数组
    NSMutableArray *timeArray;
}
@end

@implementation CloudVideoConfig

#pragma mark - 获取传入这一天当月有云视频的日期
- (void)getCloudVideoMonth:(NSDate*)date {
    dateArray =  [[NSMutableArray alloc] initWithCapacity:0];
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    SDK_SYSTEM_TIME nTime;
    nTime.year = (int)components.year;
    nTime.month = (int)components.month;
    nTime.day = 1;
    nTime.hour =0;
    nTime.minute = 0;
    nTime.second = 0;
    time_t ToTime_t(SDK_SYSTEM_TIME *time);
    int time =(int)ToTime_t(&nTime);
    MC_SearchMediaByMoth(self.MsgHandle, SZSTR(channel.deviceMac), 0, "", time,0);
}
#pragma mark  获取传入日期云存储中的云视频
- (void)searchCloudVideo:(NSDate*)date {
    fileArray = [[NSMutableArray alloc] initWithCapacity:0];
    timeArray = [[NSMutableArray alloc] initWithCapacity:0];
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    self.devID = channel.deviceMac;
    SDK_SYSTEM_TIME beginNTime;
    SDK_SYSTEM_TIME endNTime;
    NSCalendar *calendar =[NSCalendar currentCalendar];
    NSDateComponents* compt = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:date];
    
    //这里搜索一整天的，也可以根据需要自己设置搜索具体时间
    beginNTime.year = (int)compt.year;
    beginNTime.month = (int)compt.month;
    beginNTime.day = (int)compt.day;
    beginNTime.hour = 0;
    beginNTime.minute = 0;
    beginNTime.second = 0;
    
    endNTime.year = (int)compt.year;
    endNTime.month = (int)compt.month;
    endNTime.day = (int)compt.day;
    endNTime.hour = 23;
    endNTime.minute = 59;
    endNTime.second = 59;
    time_t ToTime_t(SDK_SYSTEM_TIME *time);
    int beginTime = (int)ToTime_t(&beginNTime);
    
    time_t ToTime_t(SDK_SYSTEM_TIME *time);
    int endTime = (int)ToTime_t(&endNTime);
    MC_SearchMediaByTime(self.MsgHandle, SZSTR(channel.deviceMac),  -1,"main",beginTime,endTime,0);
}

#pragma mark - 下载云视频缩略图
- (void)downloadSmallCloudThumb:(CLouldVideoResource*)resource {
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    NSString *thumbPath = [NSString thumbnailPath];
    NSString *pictureFilePath = [thumbPath stringByAppendingFormat:@"/%@.jpg",resource.indexFile];
    MC_DownloadThumbnail(self.MsgHandle, SZSTR(channel.deviceMac),SZSTR(resource.JsonStr), SZSTR(pictureFilePath), 120, 90, 0);
}
#pragma mark  下载云视频文件
- (void)downloadCloudVideoFile:(CLouldVideoResource*)resource {
    
    //存储路径
    NSString *directoryPath = [NSString getVideoPath];
    NSString *timeString = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",resource.year,resource.month,resource.day,resource.hour,resource.minute,resource.second];
    resource.storePath  = [directoryPath stringByAppendingFormat:@"/%@.mp4",timeString];
    
    //云视频时间段
    SDK_SYSTEM_TIME beginTime;
    beginTime.year = resource.year;
    beginTime.month = resource.month;
    beginTime.day = resource.day;
    beginTime.hour = resource.hour;
    beginTime.minute = resource.minute;
    beginTime.second = resource.second;
    beginTime.isdst = resource.isdst;
    
    time_t ToTime_t(SDK_SYSTEM_TIME *time);
    int beginTimeInt = (int)ToTime_t(&beginTime);
    
    SDK_SYSTEM_TIME endTime;
    [resource.endTime componentsSeparatedByString:@":"];
    [resource.endDate componentsSeparatedByString:@"-"];
    endTime.year = [[[resource.endDate componentsSeparatedByString:@"-"] firstObject] intValue];
    endTime.month = [[[resource.endDate componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
    endTime.day = [[[resource.endDate componentsSeparatedByString:@"-"] lastObject] intValue];
    endTime.hour = [[[resource.endTime componentsSeparatedByString:@":"] firstObject] intValue];
    endTime.minute = [[[resource.endTime componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
    endTime.second = [[[resource.endTime componentsSeparatedByString:@":"] lastObject] intValue];
    endTime.isdst = resource.isdst;
    
    time_t ToTime_t(SDK_SYSTEM_TIME *time);
    int endTimeInt = (int)ToTime_t(&endTime);
    
    //开始下载
    FUN_MediaCloudRecordDownload(self.MsgHandle,  SZSTR(resource.devId), 0, "", beginTimeInt, endTimeInt, SZSTR(resource.storePath),0);
}

#pragma mark - 读取获取到的一个月份中，有云视频的日期数组
- (NSMutableArray*)getMonthVideoArray {
    if (dateArray) {
        return dateArray;
    }
    return [NSMutableArray array];
}
#pragma mark  读取获取到的传入一天中的云视频数组
- (NSMutableArray*)getCloudVideoFileArray {
    if (fileArray) {
        return fileArray;
    }
    return [NSMutableArray array];
}
#pragma mark 读取这一天有录像的时间段
- (NSMutableArray*)getVideoTimeArray {
    if (timeArray) {
        return timeArray;
    }
    return [NSMutableArray array];
}
#pragma mark - OnFunSDKResult
-(void)OnFunSDKResult:(NSNumber *)pParam{
    
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    
    switch ( msg->id ) {
#pragma mark 搜索有云视频的日期回调
        case EMSG_MC_SearchMediaByMoth:{
            if ( msg->param1 >= 0 ) {
                NSData *data = [[[NSString alloc]initWithUTF8String:msg->szStr] dataUsingEncoding:NSUTF8StringEncoding];
                if ( data == nil ){
                    if ([self.delegate respondsToSelector:@selector(getCloudMonthResult:)]) {
                        [self.delegate getCloudMonthResult:0];
                    }
                    return;
            }
                NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ( appData == nil) {
                    if ([self.delegate respondsToSelector:@selector(getCloudMonthResult:)]) {
                        [self.delegate getCloudMonthResult:0];
                    }
                    return;
                }
                NSDictionary *dic = [appData objectForKey:@"AlarmCenter"];
                NSArray *dateArr = [[dic objectForKey:@"Body"] objectForKey:@"Date"];
                if (!dateArr || dateArr.count<=0) {
                    if ([self.delegate respondsToSelector:@selector(getCloudMonthResult:)]) {
                        [self.delegate getCloudMonthResult:0];
                    }
                    return;
                }
                
                for (int i = 0; i<dateArr.count; i++) {
                    [dateArray addObject:[dateArr[i] objectForKey:@"Time"]];
                }
                if ([self.delegate respondsToSelector:@selector(getCloudMonthResult:)]) {
                    [self.delegate getCloudMonthResult:msg->param1];
                }
            }
        }
            break;
#pragma mark 搜索云视频文件回调
        case EMSG_MC_SearchMediaByTime:{
            NSInteger _add = 0;
            if ( msg->param1 < 0) {
            }else{
                NSData *data = [[[NSString alloc]initWithUTF8String:msg->szStr] dataUsingEncoding:NSUTF8StringEncoding];
                if ( data == nil ){
                    if ([self.delegate respondsToSelector:@selector(getCloudVideoResult:)]) {
                        [self.delegate getCloudVideoResult:msg->param1];
                    }
                    if ([self.timeDelegate respondsToSelector:@selector(getCloudVideoTimeResult:)]) {
                        [self.timeDelegate getCloudVideoTimeResult:msg->param1];
                    }
                    return;
                }
                NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ( appData == nil ||![appData objectForKey:@"AlarmCenter"]) {
                    if ([self.delegate respondsToSelector:@selector(getCloudVideoResult:)]) {
                        [self.delegate getCloudVideoResult:msg->param1];
                    }
                    if ([self.timeDelegate respondsToSelector:@selector(getCloudVideoTimeResult:)]) {
                        [self.timeDelegate getCloudVideoTimeResult:msg->param1];
                    }
                    return;
                }
                NSDictionary *body = [[appData objectForKey:@"AlarmCenter"] objectForKey:@"Body"];
                if ( body == nil) {
                    if ([self.delegate respondsToSelector:@selector(getCloudVideoResult:)]) {
                        [self.delegate getCloudVideoResult:msg->param1];
                    }
                    if ([self.timeDelegate respondsToSelector:@selector(getCloudVideoTimeResult:)]) {
                        [self.timeDelegate getCloudVideoTimeResult:msg->param1];
                    }
                    return;
                }
                NSArray *videoArray = [body objectForKey:@"VideoArray"];
                if (videoArray.count <= 0 || videoArray == nil) {
                    if ([self.delegate respondsToSelector:@selector(getCloudVideoResult:)]) {
                        [self.delegate getCloudVideoResult:msg->param1];
                    }
                    if ([self.timeDelegate respondsToSelector:@selector(getCloudVideoTimeResult:)]) {
                        [self.timeDelegate getCloudVideoTimeResult:msg->param1];
                    }
                    return;
                }
                if (self.timeDelegate) {
                    for (int i = 0; i < 1440; i ++) {
                        [self createVideoDataWithType:TYPE_NONE andStartTime:(i*60) andEndTime:((i*60) + 60) toArray:timeArray];
                    }
                }
                for (int i = 0; i<videoArray.count; i++) {
                    CLouldVideoResource* resource = [[CLouldVideoResource alloc] init];
                    NSDictionary *infoDic = videoArray[i];
                    NSString *begin = [infoDic objectForKey:@"StartTime"];
                    NSString *beginDateString = [[begin componentsSeparatedByString:@" "] firstObject];
                    NSString *beginTimeStr =[[begin componentsSeparatedByString:@" "] lastObject];
                    
                    NSString *stop = [infoDic objectForKey:@"StopTime"];
                    NSString *stopDateString = [[stop componentsSeparatedByString:@" "] firstObject];
                    NSString *stopTimeStr =[[stop componentsSeparatedByString:@" "] lastObject];
                    
                    resource.JsonStr =  [self convertToJSONData:videoArray[i]];
                    
                    resource.devId = self.devID;
                    resource.beginDate = beginDateString;
                    resource.beginTime = beginTimeStr;
                    resource.endDate = stopDateString;
                    resource.endTime = stopTimeStr;
                    resource.indexFile = [infoDic objectForKey:@"IndexFile"];
                    
                    NSArray *dateArray = [beginDateString componentsSeparatedByString:@"-"];
                    NSArray *timeArrays = [beginTimeStr componentsSeparatedByString:@":"];
                    
                    resource.year = [[dateArray firstObject] intValue];
                    resource.month = [dateArray[1] intValue];
                    resource.day = [[dateArray lastObject] intValue];
                    resource.hour = [[timeArrays firstObject] intValue];
                    resource.minute = [timeArrays[1] intValue];
                    resource.second =[[timeArrays lastObject] intValue];
                    
                    if (self.delegate) { //设备云视频配置界面查询
                        [fileArray addObject:resource];
                    }else if (self.timeDelegate) { //云视频回放查询录像时间
                        int startTime = resource.minute + resource.hour *60;
                        NSArray *endtimeArray = [stopTimeStr componentsSeparatedByString:@":"];
                        int endMin = 0;
                        int endHou = 0;
                        if (endtimeArray.count >= 2) {
                            endMin =[[endtimeArray objectAtIndex:1] intValue];
                            endHou =[[endtimeArray firstObject] intValue];
                        }
                        int endTime = endHou *60 + endMin;
                        for (int i = 0; i< endTime-startTime+1; i++) {
                            TimeInfo *info = [[TimeInfo alloc] init];
                            info.type = TYPE_NORMAL;
                            info.start_Time = (startTime+i)*60;
                            info.end_Time = ((startTime+i) + 1)*60;
                            if (timeArray.count > startTime+i) {
                                [timeArray replaceObjectAtIndex:startTime+i withObject:info];
                            }
                            _add = (startTime+i-1)*60/4;
                        }
                    }
                }
            }
            if ([self.delegate respondsToSelector:@selector(getCloudVideoResult:)]) {
                [self.delegate getCloudVideoResult:msg->param1];
            }
            if ([self.timeDelegate respondsToSelector:@selector(addTimeDelegate:)]) {
                [self.timeDelegate addTimeDelegate:_add];
            }
            if ([self.timeDelegate respondsToSelector:@selector(getCloudVideoTimeResult:)]) {
                [self.timeDelegate getCloudVideoTimeResult:msg->param1];
            }
        }
            break;
#pragma mark 缩略图下载回调
        case EMSG_MC_DownloadMediaThumbnail:{
            NSString *path = @"";
            if (msg->param1 >=0) {
                //显示图片
                path = NSSTR(msg->szStr);
            }
            if ([self.delegate respondsToSelector:@selector(downloadSmallCloudThumbResult: path:)]) {
                [self.delegate downloadSmallCloudThumbResult:msg->param1 path:path];
            }
        }
            break;
#pragma mark 文件开始下载回调（开始下载或者失败）
        case EMSG_ON_FILE_DOWNLOAD: {
            if ([self.delegate respondsToSelector:@selector(downloadCloudVideoStartResult:)]) {
                [self.delegate downloadCloudVideoStartResult:msg->param1];
            }
        }
            break;
#pragma mark 下载进度
        case EMSG_ON_FILE_DLD_POS: {
            int download = msg->param2;
            int total = msg->param1;
            if ( total>0 ) {
                float progress = download/(float)total;
                if ([self.delegate respondsToSelector:@selector(downloadCloudVideoProgress:)]) {
                    [self.delegate downloadCloudVideoProgress:progress];
                }
            }
            
        }
            break;
#pragma mark 下载云视频完成
        case EMSG_ON_FILE_DLD_COMPLETE: {
            NSString *path = @"";
            if (msg->param1 >=0) {
                //显示图片
                path = NSSTR(msg->szStr);
            }
            if ([self.delegate respondsToSelector:@selector(downloadCloudVideoComplete:path:)]) {
                [self.delegate downloadCloudVideoComplete:msg->param1 path:path];
            }
        }
            break;
            
        default:
            break;
            
    }
}

-(NSString*)convertToJSONData:(id)infoDict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
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
@end
