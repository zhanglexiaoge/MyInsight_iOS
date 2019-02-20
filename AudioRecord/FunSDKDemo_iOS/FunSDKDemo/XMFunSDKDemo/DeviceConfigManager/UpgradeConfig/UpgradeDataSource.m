//
//  UpgradeDataSource.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/26.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "UpgradeDataSource.h"

@implementation UpgradeDataSource

- (NSString*)getUpgradeCheckState {//读取版本检查状态
     //<0,检查出错；0:没有更新的版本；1:有新的版本可供升级，云升级2:有新的版本可供升级，本地有更新版本的固件
    NSArray *array = [self getCheckStateArray];
    if (self.cState == checkStateNewest) {
        return [array objectAtIndex:0];
    }else if (self.cState  == CheckStateComplete && self.upMode == cloudUpgrade) {
        return [array objectAtIndex:1];
    }else if (self.cState  == CheckStateComplete && self.upMode == localUpgrae) {
        return [array objectAtIndex:2];
    }
    return TS("");
}
- (NSString*)getUpgradeState {//读取下载状态，如下载中、升级中、升级完成等状态
    NSArray *array = [self getUpgradeStateArray];
    if (self.upState == upgradeStateDownload) {
        return [array objectAtIndex:1];
    }else if (self.upState == upgradeStateComplete){
    return [array objectAtIndex:2];
    }else if (self.upState == upgradeStateupgrading){
        return [array objectAtIndex:3];
    }else if (self.upState == upgradeStateSuccess){
        return [array objectAtIndex:4];
    }
    return @"";
}
- (NSArray *)getCheckStateArray {
    NSArray *array = @[TS("last_Version"), TS("new_Version_on_Server"), TS("new_Version_in_APP")];
    return array;
}
- (NSArray *)getUpgradeStateArray {
    NSArray *array = @[TS(""),TS("is_Download"), TS("is_Upload"), TS("is_Upgrade"),TS("Upgrade_Success")];
    return array;
}

@end
