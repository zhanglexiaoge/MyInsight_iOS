//
//  SystemInfoConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/7.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "SystemInfoConfig.h"
#import "SystemInfo.h"

@interface SystemInfoConfig ()
{
    SystemInfo sysInfo;
}
@end

@implementation SystemInfoConfig

#pragma mark - 1、获取设备systeminfo
- (void)getSystemInfo{
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    CfgParam* paramSysInfo = [[CfgParam alloc] initWithName:@"SystemInfo" andDevId:channel.deviceMac andChannel:-1 andConfig:&sysInfo andOnce:YES andSaveLocal:NO];
    [self AddConfig:paramSysInfo];
    [self GetConfig];
}

#pragma mark - 3、解析配置信息后回调
- (void)OnGetConfig:(CfgParam *)param {
    if ( [param.name isEqualToString:[NSString stringWithUTF8String:sysInfo.Name()]]) {
        if (param.errorCode <= 0) {
            //获取设备systeminfo失败
        }else{
            ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
            DeviceObject *object  = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
            //设备升级时间
            object.info.buildTime = [NSString stringWithUTF8String:sysInfo.BuildTime.Value()];
            //设备序列号
            object.info.SerialNo = [NSString stringWithUTF8String:sysInfo.SerialNo.Value()];
            //设备硬件版本号
            object.info.hardWare = [NSString stringWithUTF8String:sysInfo.HardWare.Value()];
            //设备软件版本号
            object.info.softWareVersion = [NSString stringWithUTF8String:sysInfo.SoftWareVersion.Value()];
            //当前的网络类型
            object.info.netType = (NetTypeModel)param.param2;
            //设备模拟通道数量
            object.info.nVideoInChanNum = sysInfo.VideoInChannel.Value();
        }
        if ([self.delegate respondsToSelector:@selector(SystemInfoConfigGetResult:)]) {
            [self.delegate SystemInfoConfigGetResult:param.errorCode];
        }
    }
}

#pragma mark - 2、请求结果回调
- (void)OnFunSDKResult:(NSNumber *)pParam {
    //传回底层进行数据解析，无需其他处理
    [super OnFunSDKResult:pParam];
}

@end
