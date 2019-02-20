//
//  CloudPhotoDownloadViewController.h
//  FunSDKDemo
//
//  Created by XM on 2019/1/4.
//  Copyright © 2019年 XM. All rights reserved.
//
/******
 
 云存储图片下载显示，因为云存储图片下载没有进度回调，所以进度行没有刷新（云图片下载速度比较快）
 两张图片，一张缩略图，一张原图，（可能存在设备端没有截图的情况）
 
 *****/
#import <UIKit/UIKit.h>
#import "CloudPhotoConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CloudPhotoDownloadViewController : UIViewController

#pragma mark - 开始下载设备图片
- (void)startDownloadCloudPicture:(XMAlarmMsgResource*)msgResource;
@end

NS_ASSUME_NONNULL_END
