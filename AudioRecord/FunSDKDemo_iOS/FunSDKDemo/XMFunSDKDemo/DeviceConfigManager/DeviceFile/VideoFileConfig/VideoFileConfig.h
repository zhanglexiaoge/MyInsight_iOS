//
//  VideoFileConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/13.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 *
 *录像查询功能，包括按文件查询、按时间查询、查询一个月内哪些天有录像等等
 *录像和图片搜索方式类似，只有其中个别参数不同
 *
 ******/
@protocol VideoFileConfigDelegate <NSObject>
@optional
//获取录像代理回调
- (void)getVideoResult:(NSInteger)result;
//获取录像时间代理回调
- (void)addTimeDelegate:(NSInteger)add;

@end
#import "ConfigControllerBase.h"
#import "RecordInfo.h"
#import "TimeInfo.h"
#import "VideoContentDefination.h"

@interface VideoFileConfig : ConfigControllerBase

@property (nonatomic, assign) id <VideoFileConfigDelegate> delegate;


#pragma mark - 按文件搜索设备传入这一天的录像
- (void)getDeviceVideoByFile:(NSDate*)date;
#pragma mark - 按时间搜索传入这一天的设备录像
- (void)getDeviceVideoByTime:(NSDate*)date;
#pragma mark - 获取传入日期的这一个月内有录像的日期
- (void)getMonthVideoDate:(NSDate *)date;



#pragma mark - 读取各种请求的结果
- (NSMutableArray *)getVideoFileArray; //获取按文件请求到的录像数组
- (NSMutableArray *)getVideoTimeArray; //获取按时间请求到的录像数组
- (NSMutableArray *)getMonthVideoArray; //获取设备一个月内哪些天有录像的数组
@end
