//
//  StorageConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/8.
//  Copyright © 2018年 XM. All rights reserved.
//

/***
 
 获取设备存储容量等配置
 
*****/

@protocol StorageConfigDelegate <NSObject>

// 设备存储信息结果回调
- (void)requestDeviceStorageResult:(NSInteger)result;

// 设置循环录像结果回调
- (void)setOverWrightConfigResult:(NSInteger)result;
- (void)setKeyOverWrightConfigResult:(NSInteger)result;

// 格式化磁盘结果回调
- (void)clearStorageResult:(NSInteger)result;

@end

#import "ConfigControllerBase.h"
#import "Storage.h"

@interface StorageConfig : ConfigControllerBase

@property (nonatomic, strong) Storage *storage;

@property (nonatomic, assign) id <StorageConfigDelegate> delegate;

#pragma mark  设备存储信息请求
- (void)getStorageInfoConfig;

#pragma mark  设置循环存储功能
//普通设备循环录像
- (void)setOverWrightConfig:(NSString*)overWright;
//原始录像循环录像（运动相机等设备）
- (void)setKeyOverWrightConfig:(NSString*)overWright;

#pragma mark  格式化存储空间
- (void)clearStorage;


#pragma mark --- 获取各种配置的设置范围

- (NSMutableArray*)getEnableArray;//获取循环录像开关数组
@end
