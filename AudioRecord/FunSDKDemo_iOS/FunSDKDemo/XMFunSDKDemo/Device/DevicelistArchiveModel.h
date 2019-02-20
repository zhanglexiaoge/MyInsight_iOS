//
//  DevicelistArchiveModel.h
//  XMEye
//
//  Created by XM on 2018/4/27.
//  Copyright © 2018年 Megatron. All rights reserved.
//
/******
//设备信息本地保存和读取类
 *如果需要把设备信息保存进本地，可以在获取设备信息后调用保存，从取服务器设备列表前再读取一下，然后对比
 *
 *******/
#import <Foundation/Foundation.h>

@interface DevicelistArchiveModel : NSObject

@property (nonatomic, copy) NSString *userName;

+ (instancetype)sharedDeviceListArchiveModel;

#pragma mark - 获取保存在本地的设备列表
- (void)getSavedDeviceList:(NSString *)userName;

#pragma mark - 设备列表数据保存到本地
- (void)saveDevicelist:(NSMutableArray *)deviceArray;

#pragma mark - 传递一下当前从服务器获取到的设备列表
- (void)setReceivedSeviceArray:(NSMutableArray *)array;

#pragma mark - 判断本地读取的设备列表和获取到的设备列表是否一致
- (NSMutableArray *)devicelistCompare;
@end
