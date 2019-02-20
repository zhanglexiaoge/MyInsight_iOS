//
//  VideoRotainConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/9.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "VideoRotainConfig.h"
#import "Camera_Param.h" //摄像机参数，图像翻转、背光补偿、曝光时间、情景模式、电子慢快门、色彩模式等等
#import "VodeoRotainDataSource.h"


@interface VideoRotainConfig ()
{
    Camera_Param cameraCfg; //这里面的一些配置，并不是所有的摄像机都支持（基本所有设备都支持图像翻转功能，所以这里只设置了图像翻转的设置和获取)
    VodeoRotainDataSource *dataSourse;
}
@end

@implementation VideoRotainConfig

#pragma mark - 判断数据有效性
- (BOOL)checkParam {
    //不包含数组的数据源可以不用判断也不会出错
    return YES;
}

#pragma mark - 获取设备图像翻转状态
- (void)getRotainConfig {
    dataSourse = [[VodeoRotainDataSource alloc] init];
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //获取当前通道主码流和辅码流是否支持录像配置
    [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&cameraCfg andChannel:channel.channelNumber andCfgType:CFG_GET_SET]];
    [self GetConfig];
}
#pragma  mark - 获取摄像机参数配置回调
-(void)OnGetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:NSSTR(cameraCfg.Name())]) {
        if ([self.delegate respondsToSelector:@selector(getVideoRotainConfigResult:)]) {
            [self.delegate getVideoRotainConfigResult:param.errorCode];
        }
    }
}
#pragma mark - 保存摄像机参数状态
- (void)setRotainConfig {
    [self SetConfig];
}
#pragma mark  保存摄像机参数配置回调
-(void)OnSetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:NSSTR(cameraCfg.Name())]) {
        if ([self.delegate respondsToSelector:@selector(setVideoRotainConfigResult:)]) {
            [self.delegate setVideoRotainConfigResult:param.errorCode];
        }
    }
}

#pragma mark - 读取各项配置的属性值
- (NSString *)getPictureFlip { //获取图像上下翻转状态
    BOOL enable = cameraCfg.PictureFlip.Value();
    return [dataSourse getEnableString:enable];
}
- (NSString *)getPictureMirror { //获取图像左右翻转状态
    BOOL enable = cameraCfg.PictureMirror.Value();
    return [dataSourse getEnableString:enable];
}

#pragma mark - 设置各项配置的属性值
- (void)setPictureFlip:(NSString*)EnableString { //设置图像上下翻转状态
    BOOL enable = [dataSourse getEnableBool:EnableString];
    cameraCfg.PictureFlip = enable;
}
- (void)setPictureMirror:(NSString*)EnableString { //设置图像左右翻转状态
    BOOL enable = [dataSourse getEnableBool:EnableString];
    cameraCfg.PictureMirror= enable;
}

#pragma mark - 获取图像翻转可以设置的参数
- (NSMutableArray*)getEnableArray {//获取图像翻转开关数组
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i =0 ; i< 2; i++) {
        NSString *enable = [dataSourse getEnableString:i];
        [array addObject:enable];
    }
    return array;
}
@end
