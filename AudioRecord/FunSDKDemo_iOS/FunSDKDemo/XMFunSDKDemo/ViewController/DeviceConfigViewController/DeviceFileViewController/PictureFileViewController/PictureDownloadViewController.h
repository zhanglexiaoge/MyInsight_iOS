//
//  PictureDownloadViewController.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/16.
//  Copyright © 2018年 XM. All rights reserved.
//
/**
 *下载显示选择文件的小缩略图和原图片
 *
 *****/
#import <UIKit/UIKit.h>
#import "PictureInfo.h"

@interface PictureDownloadViewController : UIViewController

#pragma mark - 开始下载设备图片
- (void)startDownloadPicture:(PictureInfo*)pictureInfo;
@end
