//
//  DeviceControl.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/10.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "DeviceControl.h"
#import "DevicelistArchiveModel.h"
@interface DeviceControl ()
{
    NSMutableArray *deviceArray; //包含所有设备的数组
    NSMutableArray *channelPlayingArray; //即将播放的设备通道数组
    NSInteger selectChannel; //当前预览通道数组中，正在处理的通道索引（多通道预览时生效，目前只添加了一个通道进行预览，所以默认0不需要设置）
}
@end
@implementation DeviceControl

+ (instancetype)getInstance {
    static DeviceControl *Manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Manager = [[DeviceControl alloc]init];
    });
    return Manager;
}
- (id)init {
    self = [super init];
    deviceArray = [[NSMutableArray alloc] initWithCapacity:0];
    channelPlayingArray = [[NSMutableArray alloc] initWithCapacity:0];
    [DevicelistArchiveModel sharedDeviceListArchiveModel];
    return self;
}
#pragma mark  清空所有缓存的设备
- (void)clearDeviceArray {
    [deviceArray removeAllObjects];
}
#pragma mark  添加设备
- (void)addDevice:(DeviceObject*)devObject {
    [deviceArray addObject:devObject];
}
#pragma mark  获取所有设备
- (NSMutableArray*)currentDeviceArray {
    return deviceArray;
}

#pragma mark - 将要预览的设备通道数组处理
- (void)setPlayItem:(ChannelObject *)channel {
    [channelPlayingArray removeAllObjects];
    [channelPlayingArray addObject:channel];
}
- (NSMutableArray *)getPlayItem {
    return [channelPlayingArray mutableCopy];
}
- (void)cleanPlayitem {
    [channelPlayingArray removeAllObjects];
}

#pragma mark - 设置当前正要处理的通道，比如抓图录像中的通道，设备配置中的通道等
- (void)setSelectChannel:(NSInteger)selectChannel {
    selectChannel = selectChannel;
}
- (NSInteger)getSelectChannelIndex {
    return selectChannel;
}
- (ChannelObject*)getSelectChannel {
    return [channelPlayingArray objectAtIndex:selectChannel];
}
#pragma mark - 保存设备到本地存储 (设备数据发成变动时，重新存储)
- (void)saveDeviceList {
    [[DevicelistArchiveModel sharedDeviceListArchiveModel] saveDevicelist:[deviceArray mutableCopy]];
}
#pragma mark  通过序列号获取deviceObject对象
- (DeviceObject *)GetDeviceObjectBySN:(NSString *)devSN {
    if (deviceArray == nil || devSN == nil) {
        return nil;
    }
    for (int i = 0; i < deviceArray.count; i ++) {
        DeviceObject *devObject = [deviceArray objectAtIndex:i];
        if (devObject == nil) {
            continue;
        }
        if ([devObject.deviceMac isEqualToString:devSN]) {
            return devObject;
        }
    }
    return nil;
}

#pragma mark 获取channelObject对象
- (ChannelObject*)addName:(NSString*)channelName ToDeviceObject:(DeviceObject*)devObject {
    ChannelObject *object = [[ChannelObject alloc] init];
    object.channelName = channelName;
    object.deviceMac = devObject.deviceMac;
    object.loginName = devObject.loginName;
    object.loginPsw = devObject.loginPsw;
    return object;
}

#pragma mark 设备列表比较 (获取设备列表成功之后，服务器获取到的设备和本地缓存的设备比较)
- (void)checkDeviceValid {
    //传递一下数组
    [[DevicelistArchiveModel sharedDeviceListArchiveModel] setReceivedSeviceArray:deviceArray];
    //返回对比之后的设备列表数组
    NSMutableArray *array = [[DevicelistArchiveModel sharedDeviceListArchiveModel] devicelistCompare];
    if (array && array.count >0) {
        deviceArray = [array mutableCopy];
    }
}

@end
