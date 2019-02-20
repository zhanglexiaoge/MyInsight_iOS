//
//  XMAlarmMsgResource.m
//  XWorld
//
//  Created by XM on 2018/12/22.
//  Copyright © 2017年 xiongmaitech. All rights reserved.
//

#import "XMAlarmMsgResource.h"

@implementation XMAlarmMsgResource

//获取报警类型
- (NSString*)getEventString {
    NSString * videoType = @"";
    if ([self.alarmEvent isEqualToString:@"LocalAlarm"]){
        videoType = TS("Caller"); //访客来电
    }else if ([self.alarmEvent isEqualToString:@"PIRAlarm"]){
        videoType = TS("IDR_MSG_LOITERING"); //徘徊检测
    }else if ([self.alarmEvent isEqualToString:@"LowBattery"]){
        videoType = TS("IDR_LOW_BATTERY"); //低电量
    }else if ([self.alarmEvent isEqualToString:@"ReserveWakeAlarm"]){
        videoType = TS("IDR_MSG_RESERVER_WAKE"); //预约唤醒
    }else if ([self.alarmEvent isEqualToString:@"IntervalWakeAlarm"]){
        videoType = TS("IDR_MSG_INTERVAL_WAKE"); //间隔唤醒
    }else if ([self.alarmEvent isEqualToString:@"ForceDismantleAlarm"]){
        videoType = TS("IDR_MSG_FORCE_DISMANTLE"); //智能设备被拔出
    }else{
        videoType = self.alarmEvent;
    }
    return videoType;
}
@end
