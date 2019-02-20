//
//  PictureFileConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/16.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 *
 *设备图片查询功能，包括查询传入日期图片信息，以及某个月哪些天有图片等等
 *录像和图片搜索方式类似，只有其中个别参数不同
 *
 ******/
@protocol PictureFileConfigDelegate <NSObject>
@optional
//获取录像代理回调
- (void)getPictureResult:(NSInteger)result;

@end
#import "ConfigControllerBase.h"
#import "PictureInfo.h"

@interface PictureFileConfig : ConfigControllerBase
@property (nonatomic, assign) id <PictureFileConfigDelegate> delegate;

#pragma mark - 搜索传入这一天的设备图片
- (void)getDevicePictureByFile:(NSDate*)date;
#pragma mark - 获取一个月内有图片的日期
- (void)getMonthPictureDate:(NSDate *)date;

#pragma mark - 读取各种请求的结果
- (NSMutableArray *)getPictureFileArray; //获取请求到的图片数组
- (NSMutableArray *)getMonthPictureArray; //获取设备一个月内哪些天有图片的数组
@end
