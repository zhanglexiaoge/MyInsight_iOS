//
//  ChannelObject.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/10.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 
 设备通道信息
 
 *****/
#import "ObjectCoder.h"

@interface ChannelObject : ObjectCoder

@property (nonatomic, copy) NSString *deviceMac;
@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *loginPsw;
@property (nonatomic) int channelNumber;  //通道号
@property (nonatomic) BOOL isFish;  //是否是全景矫正
@end
