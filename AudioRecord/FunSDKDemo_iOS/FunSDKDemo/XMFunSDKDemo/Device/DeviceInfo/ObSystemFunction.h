//
//  ObSystemFunction.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/11.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 
设备能力级类
 
 *****/
#import "ObjectCoder.h"

@interface ObSystemFunction : ObjectCoder

@property (nonatomic, copy) NSString *deviceMac;
@property (nonatomic) int channelNumber;

@property (nonatomic) BOOL NewVideoAnalyze;//是否支持智能分析报警
@property (nonatomic) BOOL SupportIntelligentPlayBack;//是否支持智能快放
@property (nonatomic) BOOL SupportSetDigIP;//是否支持修改前端IP
@property (nonatomic) BOOL IPConsumer433Alarm;//是否支持433报警
@property (nonatomic) BOOL SupportSmartH264;//是否支持h264+

@end
