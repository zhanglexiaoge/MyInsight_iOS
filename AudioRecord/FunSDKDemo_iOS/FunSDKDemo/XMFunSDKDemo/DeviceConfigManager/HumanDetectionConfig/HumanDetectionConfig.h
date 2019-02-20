//
//  HumanDetectionConfig.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/27.
//  Copyright © 2018 wujiangbo. All rights reserved.
//
/******
 人形检测配置
人形检测能力级、报警、录像、抓图、推送消息开关等配置
*****/
#import <Foundation/Foundation.h>
#import "ConfigControllerBase.h"
NS_ASSUME_NONNULL_BEGIN


@protocol HumanDetectionDelegate <NSObject>

@optional
//获取能力级回调信息
- (void)HumanDetectionConfigGetResult:(NSInteger)result;
//设置人形检测开关回调
- (void)HumanDetectionConfigSetResult:(NSInteger)result;

@end
@interface HumanDetectionConfig : ConfigControllerBase

@property (nonatomic, assign) id <HumanDetectionDelegate> delegate;

#pragma mark - 获取人形检测配置
-(void)getHumanDetectConfig;
#pragma mark - 读取人形检测报警功能开关状态
-(int)getHumanDetectEnable;
#pragma mark - 读取人形检测报警录像开关状态
-(int)getHumanDetectRecordEnable;
#pragma mark - 读取人形检测报警抓图开关状态
-(int)getHumanDetectSnapEnable;
#pragma mark - 读取人形检测手机推送开关状态
-(int)getHumanDetectMessageEnable;
#pragma mark - 设置人形检测报警功能开关状态
-(void)setHumanDetectEnable:(int)enable;
#pragma mark - 设置人形检测报警录像开关状态
-(void)setHumanDetectRecordEnable:(int)enable;
#pragma mark - 设置人形检测报警抓图开关状态
-(void)setHumanDetectSnapEnable:(int)enable;
#pragma mark - 设置人形检测手机推送开关状态
-(void)setHumanDetectMessageEnable:(int)enable;
@end

NS_ASSUME_NONNULL_END
