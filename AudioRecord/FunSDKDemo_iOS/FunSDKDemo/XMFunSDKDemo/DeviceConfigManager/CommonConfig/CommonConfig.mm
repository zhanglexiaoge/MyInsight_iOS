//
//  CommonConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/8.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "CommonConfig.h"
#import "General_General.h"
#import "General_Location.h"

@interface CommonConfig ()
{
    General_General generalInfo;
    General_Location location; //本地化配置，夏令时、日期格式 ，这个配置因为多处用到，所以专门放在这个common类中
}
@end

@implementation CommonConfig
#pragma mark - 获取本地化配置 GeneralGenera
- (void)getGeneralGeneralConfig:(NSString *)deviceMac {
    CfgParam* paramGeneralInfo = [[CfgParam alloc] initWithName:[NSString stringWithUTF8String:generalInfo.Name()] andDevId:deviceMac andChannel:-1 andConfig:&generalInfo andOnce:YES andSaveLocal:NO];
    [self AddConfig:paramGeneralInfo];
    [self GetConfig:NSSTR(generalInfo.Name())];
}
#pragma mark - 获取本地化配置 GeneralLocation
- (void)getGeneralLocationConfig {
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //通用配置，需要用到其中的视频制式参数
    [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&location andChannel:-1 andCfgType:CFG_GET]];
    //调用获取配置的命令
    [self GetConfig:NSSTR(location.Name())];
}
#pragma mark  保存本地化配置回调
- (void)OnGetConfig:(CfgParam *)param {
    if ([param.name isEqualToString:[NSString stringWithUTF8String:generalInfo.Name()]]) {
        if (param.errorCode <= 0) {
            //获取失败
        }else{
            //获取成功
        }
    }
    if ([param.name isEqualToString:[NSString stringWithUTF8String:location.Name()]]) {
        if ([self.locationDelegate respondsToSelector:@selector(getGeneral_LocationConfigResult:)]) {
            [self.locationDelegate getGeneral_LocationConfigResult:param.errorCode];
        }
    }
}

#pragma mark - 保存本地化配置 GeneralLocation
- (void)setGeneralLocationConfig {
    [self SetConfig:NSSTR(location.Name())];
}
#pragma mark  保存本地化配置回调
-(void)OnSetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:NSSTR(location.Name())]) {
        if ([self.locationDelegate respondsToSelector:@selector(setGeneral_LocationConfigResult:)]) {
            [self.locationDelegate setGeneral_LocationConfigResult:param.errorCode];
        }
    }
}
#pragma mark - 读取各项配置的属性值 - General_Location
//获取视频制式
- (NSString *)getVideoFormat {
    return NSSTR(location.VideoFormat.Value()) ;
}
//获取夏令时开关
- (NSString*)getDSTRule {
    return NSSTR(location.DSTRule.Value());
}

#pragma mark - 设置各项配置的属性值 - General_Location
- (void)setDSTRule:(NSString*)enable { //设置夏令时开关
    location.DSTRule = SZSTR(enable);
}
- (void)setmDSTStartYear:(int)year { //设置夏令时开始年份
    location.mDSTStart.Year = year;
}
- (void)setmDSTStartMonth:(int)month {//开始月份
    location.mDSTStart.Month =month;
}
- (void)setmDSTStartDay:(int)day {//开始日期
    location.mDSTStart.Day =day;
}
- (void)setmDSTEndYear:(int)year {//结束年份
    location.mDSTEnd.Year = year;
}
- (void)setmDSTEndMonth:(int)month {//月份
    location.mDSTEnd.Month = month;
}
- (void)setmDSTEndDay:(int)day {//日期
    location.mDSTEnd.Day = day;
}

@end
