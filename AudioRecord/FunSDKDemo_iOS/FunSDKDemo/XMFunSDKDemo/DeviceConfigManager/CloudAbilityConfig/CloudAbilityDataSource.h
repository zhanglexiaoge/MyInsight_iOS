//
//  CloudAbilityDataSource.h
//  FunSDKDemo
//
//  Created by XM on 2018/12/27.
//  Copyright © 2018年 XM. All rights reserved.
//

// 云存储状态
typedef NS_ENUM(NSInteger,CloudState) {
    CloudState_UnSupport,         //  不支持
    CloudState_Open,              //  支持已开通未过期
    CloudState_Open_Expired,      //  支持开通但已过期
    CloudState_NotOpen,           //  支持未开通
};

// 云视频或云图片支持状态
typedef NS_ENUM(NSInteger,VideoOrPicCloudState) {
    VideoOrPicCloudStateNone,     // 都不支持
    VideoOrPicCloudState_Video,
    VideoOrPicCloudState_Pic,
    VideoOrPicCloudState_All,
};

#import <Foundation/Foundation.h>

@interface CloudAbilityDataSource : NSObject

@property (nonatomic, assign) CloudState cloudState;
@property (nonatomic, assign) VideoOrPicCloudState VideoOrPicState;

#pragma mark - 根据能力级读取云服务状态
- (NSString *)getCloudString;

- (NSString *)getVideoString;

- (NSString *)getPicString;
@end

