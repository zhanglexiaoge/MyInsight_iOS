//
//  AlarmMessageConfig.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/1.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "AlarmMessageConfig.h"
#import "FunSDK/Fun_MC.h"
#import "AlarmMessageInfo.h"

@implementation AlarmMessageConfig

#pragma mark - 查找报警缩略图
- (void)searchAlarmThumbnail:(NSString *)uId fileName:(NSString *)fileName
{
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    XPMS_SEARCH_ALARMPIC_REQ _req;
    memset(&_req, 0, sizeof(_req));
    STRNCPY(_req.Uuid, SZSTR(channel.deviceMac));
    _req.ID = [uId longLongValue];
    memcpy(_req.Res, "_176x144.jpeg", 32);
    MC_SearchAlarmPic(self.msgHandle, [fileName UTF8String], &_req, 0);
}

#pragma mark - 查找报警图
- (void)searchAlarmPic:(NSString *)uId fileName:(NSString *)fileName
{
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    XPMS_SEARCH_ALARMPIC_REQ _req;
    memset(&_req, 0, sizeof(_req));
    STRNCPY(_req.Uuid, SZSTR(channel.deviceMac));
    _req.ID = [uId longLongValue];
    MC_SearchAlarmPic(self.msgHandle, [fileName UTF8String], &_req, 0);
}

#pragma mark - 查询报警消息
-(void)searchAlarmInfo{
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    XPMS_SEARCH_ALARMINFO_REQ _req;
    memset(&_req, 0, sizeof(_req));
    STRNCPY(_req.Uuid, SZSTR(channel.deviceMac));
    
    _req.StarTime = [self startTime];
    _req.EndTime = [self endTime];
    _req.Channel = 0;
    _req.Number = 0;
    _req.Index = 0;
    MC_SearchAlarmInfo(self.msgHandle, &_req, 0);
}

- (struct SystemTime)startTime{
    NSDateComponents *components = [self getCurrentComponents];
    
    struct SystemTime startTime;
    memset(&startTime, 0, sizeof(startTime));
    startTime.year = (int)[components year];
    startTime.month = (int)[components month];
    startTime.day = (int)[components day];
    return startTime;
}

- (struct SystemTime)endTime{
    NSDateComponents *components = [self getCurrentComponents];
    
    struct SystemTime endTime;
    memset(&endTime, 0, sizeof(endTime));
    endTime.year = (int)[components year];
    endTime.month = (int)[components month];
    endTime.day = (int)[components day];
    endTime.hour = 23;
    endTime.second = 59;
    endTime.minute = 59;
    return endTime;
}

- (NSDateComponents *)getCurrentComponents{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"YYYY/MM/dd";
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
}

#pragma mark - SDK回调
-(void)OnFunSDKResult:(NSNumber *) pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch (msg->id) {
        case EMSG_MC_SearchAlarmInfo:{
            if (msg->param1 < 0) {
            }
            else{
                char *pStr = (char *)msg->pObject;
                NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (int i = 0; i < msg->param3; ++i) {
                    NSData *data = [[[NSString alloc]initWithUTF8String:pStr] dataUsingEncoding:NSUTF8StringEncoding];
                    AlarmMessageInfo *json = [[AlarmMessageInfo alloc]init];
                    [json parseJsonData:data];
                    NSString *startTime = [json getStartTime]; //开始时间
                    if (startTime) {
                        [dataArray addObject:json];
                    }
                    pStr += (strlen(pStr) + 1);
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(getAlarmMessageConfigResult:message:)]) {
                    [self.delegate getAlarmMessageConfigResult:msg->param1 message:dataArray];
                }
            }
        }
            break;
        case EMSG_MC_SearchAlarmPic:{
            [SVProgressHUD dismiss];
            if (msg->param1 < 0) {
                break;
            }
            //报警图
            NSString *imagePath = [NSString stringWithUTF8String:(char*)msg->szStr];
          
            if (self.delegate && [self.delegate respondsToSelector:@selector(searchAlarmPicConfigResult:imagePath:)]) {
                [self.delegate searchAlarmPicConfigResult:msg->param1 imagePath:imagePath];
            }
        }
            break;
        default:
            break;
    }
}

@end
