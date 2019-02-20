//
//  CloudAbilityConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/12/27.
//  Copyright © 2018年 XM. All rights reserved.
//
/*******
 云存储功能
 云存储照片和视频支持情况
 *******/

#import "FunMsgListener.h"
#import "CloudAbilityDataSource.h"

@protocol CloudStateRequestDelegate <NSObject>
//获取云服务能力级回调
- (void)getCloudAbilityResult:(NSInteger)result;
//获取云视频和云图片能力级回调
-(void)getVideoOrPicAbilityResult:(NSInteger)result;
@end

// 云存储能力集字段解释
// xmc.service.support 云服务是否支持
// xmc.service.enable  云服务是否开通
// xmc.service.normal  云服务是否正常使用

@interface CloudAbilityConfig : FunMsgListener

@property (nonatomic,assign) id <CloudStateRequestDelegate> delegate;

#pragma mark 请求服务器端云存储能力集
-(void)getCloudAbilityServer;

#pragma mark  是否支持云视频或云图片
-(void)getVideoOrPicAbilityServer;

#pragma mark   读取云服务状态
- (NSString*)getCloudState; //获取云存储状态
- (NSString*)getVideoEnable; //获取云视频支持情况
- (NSString*)getPicEnable; //获取云图片支持情况

@end

