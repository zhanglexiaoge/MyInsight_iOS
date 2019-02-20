//
//  BuzzerConfig.m
//  FunSDKDemo
//
//  Created by Levi on 2019/1/4.
//  Copyright © 2019年 Levi. All rights reserved.
//

#import "FunSDK/FunSDK.h"
#import "BuzzerConfig.h"
#import "DeviceControl.h"

@interface BuzzerConfig ()

@end

@implementation BuzzerConfig

#pragma mark 获取设备报警配置
- (void)getDeviceBuzzerAlarmConfig{
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    FUN_DevCmdGeneral(self.MsgHandle, SZSTR(channel.deviceMac), 1042, "Custom.AlarmBellOn", 0, 5000, NULL,0,-1,0);
}

#pragma mark 保存设备报警配置
- (void)setDeviceBuzzerAlarmConfig:(BOOL)AlarmBellState{
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    NSString * cmd = [NSString stringWithFormat:@"{\"Name\":\"Custom.AlarmBellOn\",\"Custom.AlarmBellOn\": {\"BellEnable\":   %d},\"SessionID\":\"0x00000021\"}",AlarmBellState];
    FUN_DevCmdGeneral(self.MsgHandle, SZSTR(channel.deviceMac), 1040, "Custom.AlarmBellOn", 0, 5000, strdup(SZSTR(cmd)),0,-1,0);
}

#pragma mark - Get/Set AlarmBellOnResult
-(void)OnFunSDKResult:(NSNumber *) pParam{
    [super OnFunSDKResult:pParam];
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    [SVProgressHUD dismiss];
    switch (msg->id) {
        case EMSG_DEV_CMD_EN: {
            if (msg->param1 < 0) {
                [MessageUI ShowErrorInt:msg->param1];
            }else{
#pragma mark -- 获取当前蜂鸣播放状态
                if (msg->param3 == 1042) {
                    NSDictionary *AlarmBellDic = (NSDictionary *)[super CMD_Result:pParam Name:@"Custom.AlarmBellOn"];
                    if (AlarmBellDic && AlarmBellDic.allKeys.count > 0) {
                        BOOL AlarmBellState = [[AlarmBellDic objectForKey:@"BellEnable"] boolValue];
                        if (self.delegate && [self.delegate respondsToSelector:@selector(getDeviceBuzzerAlarmConfigResult:)]) {
                            [self.delegate getDeviceBuzzerAlarmConfigResult:AlarmBellState];
                        }
                    }else{
                        [MessageUI ShowErrorInt:msg->param1];
                    }
                }else if (msg->param3 == 1040){
#pragma mark -- 设置蜂鸣播放状态结果回调
                    if (self.delegate && [self.delegate respondsToSelector:@selector(setDeviceBuzzerAlarmConfigResult:)]) {
                        [self.delegate setDeviceBuzzerAlarmConfigResult:msg->param1];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

@end
