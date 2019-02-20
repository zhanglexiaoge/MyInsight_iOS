//
//  CommonConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/8.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 
 通用的一些配置
 
 *****/
@protocol General_LocationConfigDelegate <NSObject>
//获取本地化配置代理回调
- (void)getGeneral_LocationConfigResult:(NSInteger)result;
//保存本地化配置代理回调
- (void)setGeneral_LocationConfigResult:(NSInteger)result;

@end
#import "ConfigControllerBase.h"

@interface CommonConfig : ConfigControllerBase

@property (nonatomic, assign) id <General_LocationConfigDelegate> locationDelegate;

#pragma mark - 获取本地化配置 GeneralLocation
- (void)getGeneralLocationConfig;

#pragma mark - 保存本地化配置 GeneralLocation
- (void)setGeneralLocationConfig;

#pragma mark - 读取各项配置的属性值 - General_Location
- (NSString *)getVideoFormat; //获取视频制式
- (NSString*)getDSTRule; //获取夏令时开关

#pragma mark - 设置各项配置的属性值 - General_Location
- (void)setDSTRule:(NSString*)enable ; //设置夏令时开关

- (void)setmDSTStartYear:(int)year ; //设置夏令时开始年份
- (void)setmDSTStartMonth:(int)month ;//开始月份
- (void)setmDSTStartDay:(int)day;//开始日期
- (void)setmDSTEndYear:(int)year;//结束年份
- (void)setmDSTEndMonth:(int)month ;//月份
- (void)setmDSTEndDay:(int)day;//日期
@end
