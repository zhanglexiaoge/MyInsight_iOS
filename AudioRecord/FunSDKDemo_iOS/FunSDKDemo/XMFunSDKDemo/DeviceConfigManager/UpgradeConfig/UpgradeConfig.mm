//
//  UpgradeConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/26.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "UpgradeConfig.h"

@interface UpgradeConfig()
{
    UpgradeDataSource *dataSource;  //资源和功能支持类文件
}
@end
@implementation UpgradeConfig

#pragma mark - 检查是否有新的升级文件可以升级
-(void)upgradeCheckDevice {
    //初始化需要用到的文件
    if (dataSource == nil) {
        dataSource = [[UpgradeDataSource alloc] init];
    }
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    FUN_DevCheckUpgrade(self.msgHandle, SZSTR(channel.deviceMac), 0);
}

#pragma mark - 开始升级
-(void)upgradeStartDevice {
    if (dataSource.cState != CheckStateComplete || dataSource.upState == upgradeStateDownload) {
        //不是可更新状态或者正在下载中的话，直接return
        [SVProgressHUD dismissWithError:TS("last_Version")];
        return;
    }
    //获取通道，开始升级
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    FUN_DevStartUpgrade(self.msgHandle, SZSTR(channel.deviceMac), dataSource.upMode, 0);
}

#pragma mark - 设备重启
-(void)RestartDevice {
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    char szParam[128] = {0};
    sprintf(szParam, "{\"Name\":\"OPMachine\",\"SessionID\":\"0x00000001\",\"OPMachine\":{\"Action\":\"Reboot\"}}");
    FUN_DevCmdGeneral(self.msgHandle, SZSTR(channel.deviceMac), 1450, "OPMachine", 0, 5000, szParam, 0);
}

#pragma mark  - 读取请求到的升级参数
- (NSString*)getUpgradeCheckState {//读取版本检查状态
    return [dataSource getUpgradeCheckState];
}
- (NSString*)getUpgradeState {//读取下载状态，如下载中、升级中、升级完成等状态
    return [dataSource getUpgradeState];
}
- (float)getUpgradeProgress {//读取下载和升级进度
    return dataSource.progress;
}
#pragma mark FunSDK 结果
-(void)OnFunSDKResult:(NSNumber *)pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch ( msg->id ) {
        case EMSG_DEV_CHECK_UPGRADE: {
            #pragma mark - 检查是否有新的升级文件可以升级
            if (msg->param1 == 0) {
                dataSource.cState = checkStateNewest;//没有新版本
            }else if(msg->param1 == 1) {    //有新的版本可供升级，云升级
                dataSource.cState = CheckStateComplete;
                dataSource.upMode = cloudUpgrade;     //本地升级
            } else if(msg->param1 == 2) {    //有新的版本可供升级，本地有更新版本的固件
                dataSource.cState = CheckStateComplete;
                dataSource.upMode = localUpgrae;      //云升级
            } else {
                //检查升级出错
                dataSource.cState = checkStateFaile;
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(upgradeCheckResult:)]) {
                [self.delegate upgradeCheckResult:msg->param1];
            }
        }
            break;

        case EMSG_DEV_START_UPGRADE: {
            #pragma mark - 开始升级
            if (self.delegate && [self.delegate respondsToSelector:@selector(upgradeStartDeviceResult:)]) {
                [self.delegate upgradeStartDeviceResult:msg->param1];
            }
        }
            break;

        case EMSG_DEV_ON_UPGRADE_PROGRESS: {
            #pragma mark - 升级进度
            if (msg->param1 ==EUPGRADE_STEP_DOWN) { //下载到app
                //msg->param2 下载进度
                dataSource.upState = upgradeStateDownload;
                dataSource.progress = msg->param2;
            }
            else if (msg->param1 == EUPGRADE_STEP_UP) { //上传到设备
                dataSource.upState = upgradeStateComplete;
                dataSource.progress = msg->param2;
            }
            else if (msg->param1 == EUPGRADE_STEP_UPGRADE) { //升级进度
                dataSource.upState = upgradeStateupgrading;
               dataSource.progress = msg->param2;
            }else if (msg->param1 == EUPGRADE_STEP_COMPELETE) { //升级完成
                dataSource.upState = upgradeStateSuccess;
                dataSource.progress = 100.0;
            }
            //回调到上层界面
            if(self.delegate && [self.delegate respondsToSelector:@selector(upgradeProgressDeviceResult)]){
                [self.delegate upgradeProgressDeviceResult];
            }
        }
            break;
    }
}
@end
