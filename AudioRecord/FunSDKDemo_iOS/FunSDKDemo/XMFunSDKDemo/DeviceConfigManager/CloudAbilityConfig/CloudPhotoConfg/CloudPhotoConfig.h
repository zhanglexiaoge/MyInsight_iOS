//
//  CloudPhotoConfig.h
//  FunSDKDemo
//
//  Created by XM on 2019/1/3.
//  Copyright © 2019年 XM. All rights reserved.
//
/******
 
 云服务中的云图片
 录像和图片下载不支持断点续传，如果想要后台下载，下载工具类需要设置为全局对象，根据需要进行app后台运行设置。
 
 ******/
@protocol CloudPhotoConfigDelegate <NSObject>
@optional
//获取图片日期代理回调
- (void)getCloudMonthResult:(NSInteger)result;
//获取图片信息代理回调
- (void)getCloudPictureResult:(NSInteger)result;

// 下载云存储缩略图
- (void)downloadSmallCloudPictureResult:(int)result path:(NSString *)path;
//  下载云存储原图
- (void)downloadCloudPictureResult:(int)result path:(NSString *)path;

@end
#import "ConfigControllerBase.h"
#import "XMAlarmMsgResource.h"

@interface CloudPhotoConfig : ConfigControllerBase
@property (nonatomic, assign) id <CloudPhotoConfigDelegate> delegate;

#pragma mark - 获取传入这一天当月有云图片的日期
- (void)getCloudPhotoMonth:(NSDate*)date;
#pragma mark 获取传入日期云存储中的图片
- (void)searchCloudPicture:(NSDate*)date;

#pragma mark - 下载云存储缩略图
- (void)downloadSmallCloudPicture:(XMAlarmMsgResource*)msgResource;
#pragma mark  下载云存储原图
- (void)downloadCloudPicture:(XMAlarmMsgResource*)msgResource;

#pragma mark - 读取获取到的一个月份中，有图片的日期数组
- (NSMutableArray*)getMonthPictureArray;
#pragma mark  读取获取到的传入一天中的图片数组
- (NSMutableArray*)getCloudPictureFileArray;
@end

