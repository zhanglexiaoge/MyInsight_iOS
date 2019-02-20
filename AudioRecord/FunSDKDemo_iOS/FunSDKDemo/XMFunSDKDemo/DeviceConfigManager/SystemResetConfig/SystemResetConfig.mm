//
//  SystemResetConfig.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/30.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "SystemResetConfig.h"
#import "OPDefaultConfig.h"

@interface SystemResetConfig()
{
    OPDefaultConfig jOpDefaultConfig;
}

@end
@implementation SystemResetConfig


#pragma mark  恢复出厂设置接口调用
-(void)resetDeviceConfig{
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    NSString *strCmd = [NSString stringWithFormat:@"{\"Name\":\"OPDefaultConfig\", \"OPDefaultConfig\":{\"General\":1,\"Encode\":1,\"Record\":1,\"CommPtz\":1,\"NetServer\":1,\"NetCommon\":1,\"Alarm\":1,\"Account\":1,\"Preview\":1,\"CameraPARAM\":1}}"];
    jOpDefaultConfig.Parse([strCmd UTF8String]);

    [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&jOpDefaultConfig andChannel:-1 andCfgType:CFG_SET]];
    [self SetConfig];
}

#pragma mark  配置回调
-(void)OnSetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:NSSTR(jOpDefaultConfig.Name())]) {
         if ( param.errorCode >= 0 ) {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [SVProgressHUD showSuccessWithStatus:TS("factory_settings_success")];
             });
         }
         else{
            [SVProgressHUD showErrorWithStatus:TS("factory_settings_failed")];
         }
    }
}

@end
