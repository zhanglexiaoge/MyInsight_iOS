//
//  UpgradeConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/26.
//  Copyright © 2018年 XM. All rights reserved.
//
/******
 *
 * 设备固件版本升级功能 （对监控设备进行升级）
 *1、先判断设备当前版本，如果已经是最新版本则不用升级，如果不是，则可以升级
 *2、开始升级，返回开始升级成功或者失败的结果，如果成功，继续返回升级进度
 *3、升级完成之后，可以进行一次设备重启
 *
 ******/
@protocol UpgradeConfigDelegate <NSObject>
// 检查是否有新的升级文件可以升级result:<0,检查出错；0:没有更新的版本；1:有新的版本可供升级，云升级2:有新的版本可供升级，本地有更新版本的固件
-(void)upgradeCheckResult:(int)result;

// 开始升级设备
-(void)upgradeStartDeviceResult:(int)result;

// 设备升级进度
-(void)upgradeProgressDeviceResult;

@end
#import "FunMsgListener.h"
#import "UpgradeDataSource.h"

@interface UpgradeConfig : FunMsgListener
@property (nonatomic) id<UpgradeConfigDelegate> delegate;

#pragma mark  检查是否有新的升级文件可以升级
-(void)upgradeCheckDevice;
#pragma mark  开始升级
-(void)upgradeStartDevice;
#pragma mark  设备重启
-(void)RestartDevice;

#pragma mark  - 读取请求到的升级参数
- (NSString*)getUpgradeCheckState;//读取版本检查状态

- (NSString*)getUpgradeState;//读取下载状态，如下载中、升级中、升级完成等状态

- (float)getUpgradeProgress; //读取下载和升级进度
@end
