//
//  DevicelistArchiveModel.m
//  XMEye
//
//  Created by XM on 208/4/27.
//  Copyright © 2018年 Megatron. All rights reserved.
//

#import "DevicelistArchiveModel.h"
#import "DeviceObject.h"
@implementation DevicelistArchiveModel
{
    NSMutableArray *savedArray;
    NSMutableArray *deviceArray;
}
+ (instancetype)sharedDeviceListArchiveModel {
    static DevicelistArchiveModel *sharedDeviceListModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDeviceListModel = [[DevicelistArchiveModel alloc] init];
    });
    return sharedDeviceListModel;
}
- (instancetype)init {
    self = [super init];
    return self;
}
- (void)setReceivedSeviceArray:(NSMutableArray*)array {
    deviceArray = [array mutableCopy];
}
#pragma mark - 获取保存在本地的设备列表
- (void)getSavedDeviceList:(NSString*)userName {
    //本地设备列表读区和处理
    if (userName == nil) {
        userName = @"local";
    }
    self.userName = userName;
    //1、读取本地保存的设备列表，应在登陆的时候读取
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:userName];
    @try{
        savedArray = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    if (savedArray == nil) {
        savedArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
}

#pragma mark - 设备列表数据保存到本地
- (void)saveDevicelist:(NSMutableArray *)deviceArray {
    if (deviceArray == nil || self.userName == nil || [self.userName isEqualToString:@""]) {
        return;
    }
    NSMutableArray *copyArray = [[NSMutableArray alloc]initWithArray:deviceArray copyItems:YES];//深拷贝数组文件
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (DeviceObject *deviceObj in copyArray) {//对将要保存的 数据的一些参数恢复默认
            for (ChannelObject *channel in deviceObj.channelArray) {
            }
        }
        NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:copyArray];
        if (archiveCarPriceData != nil) {
            [[NSUserDefaults standardUserDefaults] setObject:archiveCarPriceData forKey:self.userName];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    });
}
#pragma mark 判断本地读取的设备列表和获取到的设备列表是否一致
- (NSMutableArray *)devicelistCompare {
    if (deviceArray == nil || deviceArray.count == 0 || savedArray.count == 0) {
        //数据源不齐全，不比较，直接return
        return deviceArray;
    }
    //拷贝出来一个修正数组用于在对比过程中直接增删数据
    NSMutableArray *amendArray = [savedArray mutableCopy];
    //分别取出 本地设备序列号数组 和 获取到的设备序列号数组
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tmpSaveArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i =0; i< savedArray.count; i++) {
        DeviceObject *devObject = [savedArray objectAtIndex:i];
        [tmpSaveArray addObject:devObject.deviceMac];
    }
    for (int i =0; i< deviceArray.count; i++) {
        DeviceObject *devObject = [deviceArray objectAtIndex:i];
        [tmpArray addObject:devObject.deviceMac];
    }
    for (NSString *str in tmpSaveArray) {//在其他地方被删除的设备，需要从本地也删除
        if (![tmpArray containsObject:str]) {
            [amendArray removeObject:[self GetDeviceObjectBySN:str]];
        }
    }
    for (NSString *str in tmpArray) {//从其他地方添加的设备，需要在本地也添加
        if (![tmpSaveArray containsObject:str]) {
            [amendArray addObject:[deviceArray objectAtIndex:[tmpArray indexOfObject:str]]];
        }
    }
    //数据对比完成之后，再将修正数组复制给本地数组
    return [amendArray mutableCopy];
}

#pragma mark  通过序列号获取deviceObject对象
- (DeviceObject *)GetDeviceObjectBySN:(NSString *)devSN {
    if (savedArray == nil || devSN == nil) {
        return nil;
    }
    for (int i = 0; i < savedArray.count; i ++) {
        DeviceObject *devObject = [savedArray objectAtIndex:i];
        if (devObject == nil) {
            continue;
        }
        if ([devObject.deviceMac isEqualToString:devSN]) {
            return devObject;
        }
    }
    return nil;
}
@end
