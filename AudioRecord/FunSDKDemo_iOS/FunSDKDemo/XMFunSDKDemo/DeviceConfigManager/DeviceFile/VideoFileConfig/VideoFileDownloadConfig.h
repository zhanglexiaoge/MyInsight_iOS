//
//  VideoFileDownloadConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/15.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 *
 *录像下载功能，目前是在主线程操作，退出界面时会被释放，就会停止下载。
 *目前不支持断点续传，如果要实现后台下载，首先需要实现保持本类在界面退出时不被释放
 *
 ******/
@protocol FileDownloadDelegate <NSObject>
@optional
//下载录像开始回调
- (void)fileDownloadStartResult:(NSInteger)result;
//下载进度回调
- (void)fileDownloadProgressResult:(float)progress;
//下载录像结果回调
- (void)fileDownloadEndResult;

@end
#import "FunMsgListener.h"
#import "RecordInfo.h"

@interface VideoFileDownloadConfig : FunMsgListener

@property (nonatomic, assign) id <FileDownloadDelegate> delegate;

#pragma mark - 开始下载录像
- (void)downloadFile:(RecordInfo*)record;
@end
