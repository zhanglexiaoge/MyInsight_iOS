//
//  DeviceControl.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/10.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 
设备和通道信息的内存控制器，仅仅是控制内存信息，并不能用来获取设备在线状态、通道信息等等，获取设备通道信息、在线状态的方法在DeviceManager中
 
 *****/
#import <Foundation/Foundation.h>
#import "DeviceObject.h"
@interface DeviceControl : NSObject
+ (instancetype)getInstance;

#pragma mark  清空所有缓存的设备
- (void)clearDeviceArray;
#pragma mark  添加设备
- (void)addDevice:(DeviceObject *)devObject;
#pragma mark  获取所有设备
- (NSMutableArray *)currentDeviceArray;
#pragma mark 服务器获取到的设备和本地缓存的设备进行比较
- (void)checkDeviceValid;
#pragma mark 保存设备到本地存储
- (void)saveDeviceList;
#pragma mark  通过序列号获取deviceObject对象,这个只是读取设备对象，设备的在线状态和通道信息等需要使用DeviceManager中的接口先行获取
- (DeviceObject *)GetDeviceObjectBySN:(NSString *)devSN;
#pragma mark 初始化channelObject对象
- (ChannelObject *)addName:(NSString*)channelName ToDeviceObject:(DeviceObject*)devObject;

#pragma mark - 将要播放的设备和通道信息处理
- (void)setPlayItem:(ChannelObject *)channel;
- (NSMutableArray *)getPlayItem;
- (void)cleanPlayitem;

#pragma mark - 设置当前正要处理的通道，比如抓图录像中的通道，设备配置中的通道等(单画面预览时默认为0)
- (void)setSelectChannel:(NSInteger)selectChannel;
- (NSInteger)getSelectChannelIndex;
- (ChannelObject*)getSelectChannel;
@end
