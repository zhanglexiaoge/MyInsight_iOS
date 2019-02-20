//
//  CommonControl.h
//  FunSDKDemo
//
//  Created by XM on 2018/10/19.
//  Copyright © 2018年 XM. All rights reserved.
//
typedef enum deviceInfo {
    typeNone = 0,
    Iphone4 = 1,
    Iphone5 = 2,
    Iphone6 = 3,
    Iphone6P = 4,
    Iphone7 = 6,
    Iphone7P = 7,
    Iphone8 = 8,
    Iphone8P = 9,
    IphoneX = 10,
} deviceInfo;
#import <Foundation/Foundation.h>

@interface CommonControl : NSObject

@property (nonatomic) enum deviceInfo iponeVersion;

+(id)getInstance;

//获取手机信息
- (int)getDeviceString;

@end
