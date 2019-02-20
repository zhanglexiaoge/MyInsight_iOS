//
//  PictureFileDownloadConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/16.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 *
 *图片下载功能，目前是在主线程操作，退出界面时会被释放，就会停止下载。
 录像和图片下载不支持断点续传，如果想要后台下载，下载工具类需要设置为全局对象，根据需要进行app后台运行设置。
 *
 ******/
@protocol PictureDownloadDelegate <NSObject>
@optional
//缩略图下载回调
- (void)thumbDownloadResult:(NSInteger)result path:(NSString*)thumbPath;
//下载图片开始回调
- (void)pictureDownloadStartResult:(NSInteger)result;
//下载进度回调
- (void)pictureDownloadProgressResult:(float)progress;
//下载图片结果回调
- (void)pictureDownloadEndResultPath:(NSString*)path;

@end
#import "FunMsgListener.h"
#import "PictureInfo.h"

@interface PictureFileDownloadConfig : FunMsgListener
@property (nonatomic, assign) id <PictureDownloadDelegate> delegate;

#pragma mark - 开始下载缩略图片
- (void)downloadSmallPicture:(PictureInfo*)pictureInfo;
#pragma mark - 开始下载图片
- (void)downloadPicture:(PictureInfo*)pictureInfo;
@end
