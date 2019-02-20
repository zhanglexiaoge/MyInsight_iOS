//
//  SystemResetConfig.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/30.
//  Copyright © 2018 wujiangbo. All rights reserved.
//
/****
 *
 *设备恢复出厂配置
 *OPDefaultConfig.h  恢复出厂配置
 *
 ***/

#import <Foundation/Foundation.h>
#import "ConfigControllerBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface SystemResetConfig : ConfigControllerBase
#pragma mark  恢复出厂设置接口调用
-(void)resetDeviceConfig;
@end

NS_ASSUME_NONNULL_END
