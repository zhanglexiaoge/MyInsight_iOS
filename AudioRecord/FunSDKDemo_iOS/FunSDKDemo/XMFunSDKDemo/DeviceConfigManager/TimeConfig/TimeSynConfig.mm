//
//  TimeSynConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/10.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "TimeSynConfig.h"
#import "CommonConfig.h"
#import "FunSDK/FunSDK.h"
#import "System_TimeZone.h"
#import "TimeQuery.h"
#import "TimeSynDataSource.h"

@interface TimeSynConfig ()
{
    CommonConfig *common; //设备本地配置，获取夏令时，因为多个地方用到这个配置，单独放在一个类中
    System_TimeZone timeZone; // 时区
    TimeQuery *timeQ; //时间对象
    TimeSynDataSource *dataSource; //资源和功能支持类文件
}

@end
@implementation TimeSynConfig
#pragma mark - 获取设备夏令时、时间、时区
- (void)getTimeZoneConfig {
    //初始化需要用到的两个头文件
    dataSource = [[TimeSynDataSource alloc] init];
    timeQ = [[TimeQuery alloc] init];
    
    [self getTimeRule];//获取设备夏令时配置
    [self gettimeZone];//获取设备时区
    [self getTime];//获取设备时间
}
- (void)getTimeRule { //获取夏令时
    common = [[CommonConfig alloc] init];
    [common getGeneralLocationConfig];
}
- (void)gettimeZone { //获取时区
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //通用配置，需要用到其中的视频制式参数
    [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&timeZone andChannel:-1 andCfgType:CFG_GET_SET]];
    //调用获取配置的命令
    [self GetConfig:NSSTR(timeZone.Name())];
}
- (void)getTime {
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //cmd配置，获取设备时间
    FUN_DevCmdGeneral(self.MsgHandle, SZSTR(channel.deviceMac), 1452, SZSTR(TIMEQUERY), 0, 5000, NULL, 0, -1, 0);
}
#pragma mark - 保存设备夏令时、时区、时间
- (void)setTimeSynConfig { //设置时间、时区、夏令时同步e
    //1、根据手机所在地规则设置设备夏令时开关
    [self setDSTRule];
    //2、根据手机时区设置设备时区
    [self setSystemTimeZone];
    //3、根据手机时间设置设备时间
    [self setSystemTime];
}
- (void)setDSTRule { //1、根据手机所在地规则设置设备夏令时开关
    NSArray *arrayBegin = [TimeSynDataSource getDayLightSavingBeginTime];
    NSArray *arrayEnd = [TimeSynDataSource getDayLightSavingEndTime];
    if ([arrayBegin.firstObject intValue] != 0) {
        //设置夏令时开
       [common setDSTRule:@"On"];
        //设置夏令时开始时间
        [common setmDSTStartYear:[arrayBegin[0] intValue]];
        [common setmDSTStartMonth:[arrayBegin[1] intValue]];
        [common setmDSTStartDay:[arrayBegin[2] intValue]];
        //设置夏令时结束时间
        [common setmDSTEndYear:[arrayEnd[0] intValue]];
        [common setmDSTEndMonth:[arrayEnd[1] intValue]];
        [common setmDSTEndDay:[arrayEnd[2] intValue]];
    }
    else{
        //设置夏令时关
        [common setDSTRule:@"Off"];
    }
    //保存配置
    [common setGeneralLocationConfig];
}
- (void)setSystemTimeZone { //2、根据手机时区设置设备时区
    //先获取手机所在位置的时区
    int myTime =[dataSource getSystemTimeZone];
    timeZone.timeMin = myTime;
    [self SetConfig:NSSTR(timeZone.Name())];
}
- (void)setSystemTime { //3、根据手机时间设置设备时间
    NSString *timeString = [dataSource getSystemTimeString];
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //调用保存设备时间的接口
    FUN_DevCmdGeneral(self.MsgHandle, SZSTR(channel.deviceMac), 1450, "OPTimeSetting", 0, 5000, (char*)SZSTR(timeString), 0);
}
#pragma  mark - 获取摄像机参数配置回调
-(void)OnGetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:NSSTR(timeZone.Name())]) {
        if ([self.delegate respondsToSelector:@selector(getTimeSynConfigResult:)]) {
            [self.delegate getTimeSynConfigResult:param.errorCode];
        }
    }
}
#pragma mark  保存摄像机参数配置回调
-(void)OnSetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:NSSTR(timeZone.Name())]) {
        if ([self.delegate respondsToSelector:@selector(setTimeSynConfigResult:)]) {
            [self.delegate setTimeSynConfigResult:param.errorCode];
        }
    }
}
#pragma mark - 读取各项配置的属性值
- (NSString *)getTimeZone { //读取时区
    int zone = timeZone.timeMin.Value();
    return [dataSource parseTimeZone:zone];
}
- (NSString *)getTimeQuery { //读取时间
    return timeQ.timeStr;
}
- (NSString *)getDSTRule { //获取当前夏令时状态
    return [common getDSTRule];
}

#pragma mark -
- (void)OnFunSDKResult:(NSNumber *) pParam{
    [super OnFunSDKResult:pParam];
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    if (msg->id == EMSG_DEV_CMD_EN && msg->param3 == 1452) { //获取时间
        NSString *time = (NSString*)[super CMD_Result:pParam Name:TIMEQUERY];
        timeQ.timeStr = time;
        if ([self.delegate respondsToSelector:@selector(getTimeSynConfigResult:)]) {
            [self.delegate getTimeSynConfigResult:msg->param1];
        }
    }
    if (msg->id == EMSG_DEV_CMD_EN && msg->param3 == 1450) { //保存时间
        if ([self.delegate respondsToSelector:@selector(setTimeSynConfigResult:)]) {
            [self.delegate setTimeSynConfigResult:msg->param1];
        }
    }
}
@end
