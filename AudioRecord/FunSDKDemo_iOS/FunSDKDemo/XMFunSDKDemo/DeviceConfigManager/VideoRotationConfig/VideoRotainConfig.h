//
//  VideoRotainConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/9.
//  Copyright © 2018年 XM. All rights reserved.
//
/******
 *
 * 视频图像翻转功能
 *
 *
 ******/
@protocol VideoRotainConfigDelegate <NSObject>
//获取摄像机参数代理回调
- (void)getVideoRotainConfigResult:(NSInteger)result;
//保存摄像机参数代理回调
- (void)setVideoRotainConfigResult:(NSInteger)result;

@end
#import "ConfigControllerBase.h"

@interface VideoRotainConfig : ConfigControllerBase

@property (nonatomic, assign) id <VideoRotainConfigDelegate> delegate;

#pragma mark - 判断数据有效性
- (BOOL)checkParam;

#pragma mark - 获取设备图像翻转状态
- (void)getRotainConfig;

#pragma mark - 保存摄像机参数状态
- (void)setRotainConfig;

#pragma mark - 读取各项配置的属性值
- (NSString *)getPictureFlip; //获取图像上下翻转状态
- (NSString *)getPictureMirror; //获取图像左右翻转状态
    
#pragma mark - 设置各项配置的属性值
- (void)setPictureFlip:(NSString*)EnableString; //设置图像上下翻转状态
- (void)setPictureMirror:(NSString*)EnableString; //设置图像左右翻转状态

#pragma mark - 获取图像翻转可以设置的参数
- (NSMutableArray*)getEnableArray;
@end
