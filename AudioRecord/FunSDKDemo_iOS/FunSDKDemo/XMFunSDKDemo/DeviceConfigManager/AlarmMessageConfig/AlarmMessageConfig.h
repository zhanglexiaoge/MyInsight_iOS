//
//  AlarmMessageConfig.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/1.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

/****
 *
 *设备报警消息查询配置
 *获取报警消息
 *根据消息id和图片名称获取缩略图
 *根据消息id和图片名称获取报警原图
 *
 ***/
#import <Foundation/Foundation.h>
#import "FunMsgListener.h"
NS_ASSUME_NONNULL_BEGIN

@protocol AlarmMessageConfigDelegate <NSObject>

//获取报警消息回调
-(void)getAlarmMessageConfigResult:(NSInteger)result message:(NSMutableArray *)array;
//搜索报警消息图片回调
-(void)searchAlarmPicConfigResult:(NSInteger)result imagePath:(NSString *)imagePath;
@end

@interface AlarmMessageConfig : FunMsgListener

@property (nonatomic, assign) id <AlarmMessageConfigDelegate> delegate;
#pragma mark - 查找报警缩略图
- (void)searchAlarmThumbnail:(NSString *)uId fileName:(NSString *)fileName;
#pragma mark - 查找报警图
- (void)searchAlarmPic:(NSString *)uId fileName:(NSString *)fileName;
#pragma mark - 查询报警消息
-(void)searchAlarmInfo;
@end

NS_ASSUME_NONNULL_END
