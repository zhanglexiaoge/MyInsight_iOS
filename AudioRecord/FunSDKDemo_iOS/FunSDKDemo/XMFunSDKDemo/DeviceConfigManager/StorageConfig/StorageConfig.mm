//
//  StorageConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/8.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "FunSDK/netsdk.h"
#import "FunSDK/FunSDK.h"
#import "StorageConfig.h"
#import "StorageInfo.h"
#import "OPStorageManager.h"
#import "StorageGlobal.h"
#import "General_General.h"
#import "DataSource.h"

@interface StorageConfig ()
{
    JObjArray<StorageInfo> storageInfo;
    OPStorageManager storageManager;
    StorageGlobal global;
    General_General generalInfo;
    
    DataSource *dataSource;
}
@end

@implementation StorageConfig

- (id)init {
    self = [super init];
    if (self) {
        dataSource = [[DataSource alloc] init];
        self.storage = [[Storage alloc] init];
    }
    return self;
}
#pragma mark  设备信息请求
- (void)getStorageInfoConfig {
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    // 1.0 获取普通录像循环录像开关
    CfgParam* paramGeneralInfo = [[CfgParam alloc] initWithName:[NSString stringWithUTF8String:generalInfo.Name()] andDevId:channel.deviceMac andChannel:-1 andConfig:&generalInfo andOnce:YES andSaveLocal:NO];
    [self AddConfig:paramGeneralInfo];
    [self GetConfig:[NSString stringWithUTF8String:generalInfo.Name()]];
    
//    // 2.0 获取设备原始码流循环录像开关 （是勇士类支持原始码流的设备配置,所以这里没有请求）
//    CfgParam* paramglobal = [[CfgParam alloc] initWithName:[NSString stringWithUTF8String:global.Name()] andDevId:channel.deviceMac andChannel:-1 andConfig:&global andOnce:YES andSaveLocal:NO];
//    [self AddConfig:paramglobal];
//    [self GetConfig:[NSString stringWithUTF8String:global.Name()]];
    
    // 3.0 获取设备存储信息
    storageInfo.SetName(JK_StorageInfo);
    CfgParam* paramStorageInfo = [[CfgParam alloc] initWithName:[NSString stringWithUTF8String:storageInfo.Name()] andDevId:channel.deviceMac andChannel:-1 andConfig:&storageInfo andOnce:YES andSaveLocal:NO];
    [self AddConfig:paramStorageInfo];
    [self GetConfig:[NSString stringWithUTF8String:storageInfo.Name()]];
    
    // 4.0 添加设备格式化配置  格式化配置请求无效，只能进行设置，所以这里没有进行请求
    storageManager.SetName(JK_OPStorageManager);
    CfgParam* paramStorageManager = [[CfgParam alloc] initWithName:[NSString stringWithUTF8String:storageManager.Name()] andDevId:channel.deviceMac andChannel:-1 andConfig:&storageManager andOnce:YES andSaveLocal:NO];
    [self AddConfig:paramStorageManager];
}

#pragma mark  设置循环存储功能
- (void)setOverWrightConfig:(NSString*)overWright {
    BOOL enable = [dataSource getEnableBool:overWright];
    if (enable) {generalInfo.OverWrite = [@"OverWrite" UTF8String];}
    if (!enable) {generalInfo.OverWrite = [@"StopRecord" UTF8String];}
    [self SetConfig:[NSString stringWithUTF8String:generalInfo.Name()]];
}
- (void)setKeyOverWrightConfig:(NSString*)overWright {
     BOOL enable = [dataSource getEnableBool:overWright];
    global.KeyOverWrite = enable;
    [self SetConfig:[NSString stringWithUTF8String:global.Name()]];
}

#pragma mark  格式化存储空间
int format = 0;
- (void)clearStorage {
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    storageManager.Action = "Clear";
    //循环格式化所有磁盘和分区
    for (int i = 0; i < storageInfo.Size(); ++i) {
        for (int j = 0; j < storageInfo[i].Partition.Size(); ++j) {
            storageManager.SerialNo = i;
            storageManager.PartNo = j;
            storageManager.Type = "Data";
            const char* pCfgBuf = storageManager.ToString();
            FUN_DevSetConfig_Json(self.MsgHandle, SZSTR(channel.deviceMac), storageManager.Name(), pCfgBuf, (int)strlen(pCfgBuf), -1, 25000);
            format++;//格式化磁盘的数量
        }
    }
}

#pragma mark 获取设备存储配置回调接口
- (void)OnGetConfig:(CfgParam *)param {
    if ([param.name isEqualToString:[NSString stringWithUTF8String:storageInfo.Name()]]) {
        if (param.errorCode <= 0) {
        }else {                    //普通设备的存储容量不分开计算
            for(int i = 0; i < SDK_MAX_DISK_PER_MACHINE && i < storageInfo.Size(); ++i){
                //总录像容量
                self.storage.videoTotalStorage += storageInfo[i].Partition[0].TotalSpace.Value();
                //空闲录像容量
                self.storage.videoFreeStorage += storageInfo[i].Partition[0].RemainSpace.Value();
                
                if (storageInfo[i].Partition.Size() > 1) {
                    //总的图片容量
                    self.storage.imgTotalStorage += storageInfo[i].Partition[1].TotalSpace.Value();
                    //空闲图片容量
                    self.storage.imgFreeStorage += storageInfo[i].Partition[1].RemainSpace.Value();
                }
            }
            //总容量
            self.storage.totalStorage = self.storage.videoTotalStorage +self.storage.imgTotalStorage;
            //总空闲容量
            self.storage.freeStorage = self.storage.videoFreeStorage +self.storage.imgFreeStorage;
        }
        if ([self.delegate respondsToSelector:@selector(requestDeviceStorageResult:)]) {
            [self.delegate requestDeviceStorageResult:param.errorCode];
        }
    }
    if ([param.name isEqualToString:[NSString stringWithUTF8String:global.Name()]]) {
        if (param.errorCode <= 0) {
        }
        //原始录像循环覆盖参数（运动相机等）
        NSString *enable = [dataSource getEnableString:global.KeyOverWrite.Value()];
        self.storage.keyOverWrite = enable;
        if ([self.delegate respondsToSelector:@selector(requestDeviceStorageResult:)]) {
            [self.delegate requestDeviceStorageResult:param.errorCode];
        }
    }
    if ([param.name isEqualToString:[NSString stringWithUTF8String:generalInfo.Name()]]) {
        if (param.errorCode <= 0) {
        }
        //普通录像循环覆盖参数
        if ([[NSString stringWithUTF8String:generalInfo.OverWrite.Value()] isEqualToString:@"StopRecord"]) {
            NSString *enable = [dataSource getEnableString:NO];
            self.storage.overWright = enable;
        }
        if ([[NSString stringWithUTF8String:generalInfo.OverWrite.Value()] isEqualToString:@"OverWrite"]) {
            NSString *enable = [dataSource getEnableString:YES];
            self.storage.overWright = enable;
        }
        if ([self.delegate respondsToSelector:@selector(requestDeviceStorageResult:)]) {
            [self.delegate requestDeviceStorageResult:param.errorCode];
        }
    }
}

#pragma mark - 获取设备存储信息回调
- (void)OnFunSDKResult:(NSNumber *)pParam {
    [super OnFunSDKResult:pParam];
}
#pragma mark 保存设备存储配置回调
- (void)OnSetConfig:(CfgParam *)param {
    if ( [param.name isEqualToString:[NSString stringWithUTF8String:generalInfo.Name()]] ) {
        //普通录像循环录像开关设置
        if (param.errorCode <= 0) {
            //设置失败
        }
        if(strcmp(generalInfo.OverWrite.Value(), "StopRecord") == 0?true:false) {
            //停止循环录像
        }
        else {
            //开始循环录像
        }
        if ([self.delegate respondsToSelector:@selector(setOverWrightConfigResult:)]) {
            [self.delegate setOverWrightConfigResult:param.errorCode];
        }
    }
    if ([param.name isEqualToString:[NSString stringWithUTF8String:global.Name()]]) {
        //原始录像循环录像开关设置
        if (param.errorCode <= 0) {
        }
        if ([self.delegate respondsToSelector:@selector(setKeyOverWrightConfigResult:)]) {
            [self.delegate setKeyOverWrightConfigResult:param.errorCode];
        }
    }
    if ([param.name isEqualToString:[NSString stringWithUTF8String:storageManager.Name()]]) {
        format--;
        if (param.errorCode <= 0) {
            //当前这个磁盘格式化失败
        }
        if (format == 0) {
            //所有磁盘格式化结束
            if ([self.delegate respondsToSelector:@selector(clearStorageResult:)]) {
                [self.delegate clearStorageResult:param.errorCode];
            }
        }
    }
}

#pragma mark - //获取循环录像开关数组
- (NSMutableArray*)getEnableArray {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i =0 ; i< 2; i++) {
        NSString *enable = [dataSource getEnableString:i];
        [array addObject:enable];
    }
    return array;
}
@end
