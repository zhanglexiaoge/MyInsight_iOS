//
//  AnalyzeConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/12/22.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 
 设备智能分析配置
1、需要先获取设备能力级，判断是否支持智能分析
 
 *****/
@protocol AnalyzeConfigDelegate <NSObject>
//获取智能分析代理回调
- (void)getAnalyzeConfigResult:(NSInteger)result;
//保存智能分析代理回调
- (void)setAnalyzeConfigResult:(NSInteger)result;

@end
#import "ConfigControllerBase.h"
#import "AnalyzeDataSource.h"

@interface AnalyzeConfig : ConfigControllerBase

@property (nonatomic, assign) id <AnalyzeConfigDelegate> delegate;

#pragma mark  获取智能分析数据对象
- (AnalyzeDataSource*)getAnalyzeDataSource; //

#pragma mark  判断当前数据是否有效 （比如获取到的数据异常）
- (BOOL)checkParam ;

#pragma mark  请求智能分析
- (void)getAnalyzeConfig;
#pragma mark  保存智能分析配置
- (void)setAnalyzeConfig;

- (NSMutableArray*)getEnableArray;//获取码流开关数组

@end
