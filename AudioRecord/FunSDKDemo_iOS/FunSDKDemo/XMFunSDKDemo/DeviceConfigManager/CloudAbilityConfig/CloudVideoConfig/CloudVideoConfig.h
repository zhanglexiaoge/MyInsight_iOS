//
//  CloudVideoConfig.h
//  FunSDKDemo
//
//  Created by XM on 2019/1/7.
//  Copyright © 2019年 XM. All rights reserved.
//
/***
 *
 *云存储录像查询功能，查询一个月内哪些天有录像等等
 *录像和图片搜索方式类似，只有其中个别参数不同
 *录像和图片下载不支持断点续传，如果想要后台下载，下载工具类需要设置为全局对象，根据需要进行app后台运行设置。
 *下载后的录像可以在app相册中播放
 ******/
@protocol CloudVideoConfigDelegate <NSObject>
@optional
//获取云视频日期代理回调
- (void)getCloudMonthResult:(NSInteger)result;
//获取云视频信息代理回调
- (void)getCloudVideoResult:(NSInteger)result;

// 下载云存储缩略图
- (void)downloadSmallCloudThumbResult:(int)result path:(NSString *)path;
//  下载云存储视频开始
- (void)downloadCloudVideoStartResult:(int)result;
// 下载视频进度
- (void)downloadCloudVideoProgress:(float)progress;
// 下载视频完成
- (void)downloadCloudVideoComplete:(int)result path:(NSString*)path;

@end
@protocol CloudVideoTimeDelegate <NSObject>
@optional
//获取云视频信息代理回调
- (void)getCloudVideoTimeResult:(NSInteger)result;
//获取云视频时间代理回调
- (void)addTimeDelegate:(NSInteger)add;

@end
#import "ConfigControllerBase.h"
#import "CLouldVideoResource.h"

@interface CloudVideoConfig : ConfigControllerBase

@property (nonatomic, assign) id <CloudVideoConfigDelegate> delegate;
@property (nonatomic, assign) id <CloudVideoTimeDelegate> timeDelegate;

#pragma mark - 获取传入这一天当月有云视频的日期
- (void)getCloudVideoMonth:(NSDate*)date;
#pragma mark 获取传入日期云存储中的视频
- (void)searchCloudVideo:(NSDate*)date;

#pragma mark - 下载云视频缩略图
- (void)downloadSmallCloudThumb:(CLouldVideoResource*)resource;
#pragma mark  下载云视频文件
- (void)downloadCloudVideoFile:(CLouldVideoResource*)resource;

#pragma mark - 读取获取到的一个月份中，有云视频的日期数组
- (NSMutableArray*)getMonthVideoArray;
#pragma mark  读取获取到的传入一天中的云视频数组
- (NSMutableArray*)getCloudVideoFileArray;
#pragma mark 读取这一天有录像的时间段
- (NSMutableArray*)getVideoTimeArray;
@end

