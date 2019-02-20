//
//  DeviceInfoEditViewController.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/19.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//
/**
 
 序列号添加设备视图控制器
 *1、输入设备名称，设备密码。(用户名也可通过接口修改，默认admin）
 *2、设置设备名称和设备密码
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfoEditViewController : UIViewController
@property (nonatomic, copy) void(^editSuccess)(void);     //编辑成功
@property(nonatomic,strong)DeviceObject *devObject;       //当前选中设备

@end

NS_ASSUME_NONNULL_END
