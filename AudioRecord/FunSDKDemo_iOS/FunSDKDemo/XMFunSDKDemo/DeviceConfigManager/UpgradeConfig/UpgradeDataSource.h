//
//  UpgradeDataSource.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/26.
//  Copyright © 2018年 XM. All rights reserved.
//

#import <Foundation/Foundation.h>

enum checkState {
    checkStateNone,//默认状态
    checkStateCheckIng,//检查中
    checkStateFaile,//检查版本失败
    checkStateNewest,//已是最新版本
    CheckStateComplete,//检查完成，有新版本
};
enum upgradeState {
    upgradeStateNone,//默认状态
    upgradeStateDownload,//下载状态
    upgradeStateComplete,//下载完成等待升级(上传到设备)
    upgradeStateupgrading,//升级中
    upgradeStateSuccess //升级完成
};
enum upgradeMode {
    localUpgrae = 1,   //本地升级
    cloudUpgrade,      //云升级
};

@interface UpgradeDataSource : NSObject

@property (nonatomic) enum checkState cState;
@property (nonatomic) enum upgradeState upState;
@property (nonatomic) enum upgradeMode upMode;

@property (nonatomic,assign) float progress; //下载和升级进度

- (NSString*)getUpgradeCheckState;//读取版本检查状态

- (NSString*)getUpgradeState;//读取下载状态，如下载中、升级中、升级完成等状态
@end
