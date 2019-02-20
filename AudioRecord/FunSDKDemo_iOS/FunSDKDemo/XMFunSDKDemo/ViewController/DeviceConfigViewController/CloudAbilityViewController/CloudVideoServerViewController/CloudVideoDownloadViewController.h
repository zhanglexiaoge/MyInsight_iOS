//
//  CloudVideoDownloadViewController.h
//  FunSDKDemo
//
//  Created by XM on 2019/1/7.
//  Copyright © 2019年 XM. All rights reserved.
//
/******
 
 云视频文件下载
 
 *****/
#import <UIKit/UIKit.h>
#import "CloudVideoConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CloudVideoDownloadViewController : UIViewController

#pragma mark - 开始下载云视频录像
- (void)startDownloadCloudVideo:(CLouldVideoResource*)msgResource;
@end

NS_ASSUME_NONNULL_END
