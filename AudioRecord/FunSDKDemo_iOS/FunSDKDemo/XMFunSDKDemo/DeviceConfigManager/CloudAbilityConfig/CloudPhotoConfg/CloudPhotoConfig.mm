//
//  CloudPhotoConfig.m
//  FunSDKDemo
//
//  Created by XM on 2019/1/3.
//  Copyright © 2019年 XM. All rights reserved.
//

#import "CloudPhotoConfig.h"
#import "FunSDK/FunSDK.h"
#import "FunSDK/Fun_MC.h"

@interface CloudPhotoConfig ()
{
    NSMutableArray *fileArray;  //搜索某一天的图片数组结果
    NSMutableArray *dateArray; //搜索某一个月哪些天有图片的结果数组
}
@end

@implementation CloudPhotoConfig

#pragma mark - 获取传入这一天当月有云图片的日期
- (void)getCloudPhotoMonth:(NSDate*)date {
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
    MC_SearchAlarmByMoth(self.MsgHandle, SZSTR(channel.deviceMac), 0, "", time,0);
}

#pragma mark  获取传入日期云存储中的图片
- (void)searchCloudPicture:(NSDate*)date {
    fileArray = [[NSMutableArray alloc] initWithCapacity:0];
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    XPMS_SEARCH_ALARMINFO_REQ alarmInfo = {0};
    strcpy(alarmInfo.Uuid, SZSTR(channel.deviceMac));
    alarmInfo.Channel = channel.channelNumber;
    alarmInfo.Number = -1;
    alarmInfo.Index = 0;
    
    NSCalendar *calendar =[NSCalendar currentCalendar];
    NSDateComponents* compt = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:date];
    
    alarmInfo.StarTime.year = (int)compt.year;
    alarmInfo.StarTime.month = (int)compt.month;
    alarmInfo.StarTime.day = (int)compt.day;
    alarmInfo.StarTime.hour = 0;
    alarmInfo.StarTime.minute = 0;
    alarmInfo.StarTime.second = 0;
    
    alarmInfo.EndTime.year = (int)compt.year;
    alarmInfo.EndTime.month = (int)compt.month;
    alarmInfo.EndTime.day = (int)compt.day;
    alarmInfo.EndTime.hour = 23;
    alarmInfo.EndTime.minute = 59;
    alarmInfo.EndTime.second = 59;
    MC_SearchAlarmInfoByTime(self.MsgHandle, &alarmInfo,1);
}

#pragma mark - 下载云存储缩略图
- (void)downloadSmallCloudPicture:(XMAlarmMsgResource*)msgResource {
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    NSString *thumbPath = [NSString thumbnailPath];
    NSString *pictureFilePath = [thumbPath stringByAppendingFormat:@"/%@.jpg",msgResource.ID];
    //下载缩略图，大小可以客户端自己定义
    int width = 60;
    MC_DownloadAlarmImage(self.MsgHandle, SZSTR(channel.deviceMac), SZSTR(pictureFilePath), SZSTR(msgResource.JsonStr), width, width, 0);
}
#pragma mark  下载云存储原图
- (void)downloadCloudPicture:(XMAlarmMsgResource*)msgResource {
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    NSString *filePath = [NSString pictureFilePath];
    NSString *pictureFilePath = [filePath stringByAppendingFormat:@"/%@.jpg",msgResource.ID];
    MC_DownloadAlarmImage(self.MsgHandle, SZSTR(channel.deviceMac), SZSTR(pictureFilePath), SZSTR(msgResource.JsonStr), 0, 0, 1);
}

#pragma mark - 读取当前月份哪些日期有云存储图片
- (NSMutableArray*)getMonthPictureArray {
    if (dateArray) {
        return dateArray;
    }
    return [NSMutableArray array];
}
#pragma mark -读取获取到的传入一天中的图片数组
- (NSMutableArray*)getCloudPictureFileArray {
    if (fileArray) {
        return fileArray;
    }
    return [NSMutableArray array];
}
#pragma mark - OnFunSDKResult
-(void)OnFunSDKResult:(NSNumber *)pParam{
    
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    
    switch ( msg->id ) {
            #pragma mark 搜索有云图片的日期回调
        case EMSG_MC_SearchAlarmByMoth:{
            NSData *data = [[[NSString alloc]initWithUTF8String:msg->szStr] dataUsingEncoding:NSUTF8StringEncoding];
            if ( data == nil ) {
                if ([self.delegate respondsToSelector:@selector(getCloudMonthResult:)]) {
                    [self.delegate getCloudMonthResult:msg->param1];
                }
                return;
            }
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ( appData == nil) {
                if ([self.delegate respondsToSelector:@selector(getCloudMonthResult:)]) {
                    [self.delegate getCloudMonthResult:msg->param1];
                }
                return;
            }
            
            NSDictionary *dic = [appData objectForKey:@"AlarmCenter"];
            NSArray *dateArr = [[dic objectForKey:@"Body"] objectForKey:@"Date"];
            if (!dateArr || dateArr.count<=0) {
                if ([self.delegate respondsToSelector:@selector(getCloudMonthResult:)]) {
                    [self.delegate getCloudMonthResult:msg->param1];
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
            break;
            #pragma mark 搜索云图片文件信息回调
        case EMSG_MC_SearchAlarmInfo: {
            int num = msg->param3;//报警个数

            char *pStr = (char *)msg->pObject;
            for (int i = 0; i < num; i++) {
                //解析
                NSData *data = [[[NSString alloc]initWithUTF8String:pStr] dataUsingEncoding:NSUTF8StringEncoding];
                
                if (data) {
                    NSError *error;
                    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                    NSDictionary *alarmInfoDic = dataDic[@"AlarmInfo"];
                   
                    XMAlarmMsgResource *resource = [[XMAlarmMsgResource alloc] init];
                    
                    resource.ID = dataDic[@"ID"];
                    resource.size = [dataDic[@"picSize"] intValue];
                    resource.picUrl = alarmInfoDic[@"Pic"];
                    if (resource.picUrl) {
                        resource.thumbnailPicUrl = [resource.picUrl stringByAppendingString:@"_176x144.jpeg"];
                    }
                    resource.channel = [alarmInfoDic[@"Channel"] intValue];
                    resource.startTime = alarmInfoDic[@"StartTime"];
                    
                    resource.alarmEvent = alarmInfoDic[@"Event"];
                    
                    NSDictionary *dicPicInfo = [[dataDic objectForKey:@"AlarmInfo"] objectForKey:@"PicInfo"];
                    if (dicPicInfo) {
                        resource.ObjName = [dicPicInfo objectForKey:@"ObjName"];
                        resource.StorageBucket = [dicPicInfo objectForKey:@"StorageBucket"];
                        
                        resource.JsonStr = [self convertToJSONData:dataDic];
                    }
                    [fileArray addObject:resource];
                }
            }
            if ([self.delegate respondsToSelector:@selector(getCloudPictureResult:)]) {
                [self.delegate getCloudPictureResult:msg->param1];
            }
        }
            break;
            #pragma mark 下载云图片回调 （缩略图和原图）
        case EMSG_MC_SearchAlarmPic:{
            NSString *path = @"";
            if (msg->param1 >=0) {
                //显示图片
                path = NSSTR(msg->szStr);
            }
            if (msg->seq == 0) {
                if ([self.delegate respondsToSelector:@selector(downloadSmallCloudPictureResult: path:)]) {
                    [self.delegate downloadSmallCloudPictureResult:msg->param1 path:path];
                }
            }else if (msg->seq == 1) {
                if ([self.delegate respondsToSelector:@selector(downloadCloudPictureResult: path:)]) {
                    [self.delegate downloadCloudPictureResult:msg->param1 path:path];
                }
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
@end
