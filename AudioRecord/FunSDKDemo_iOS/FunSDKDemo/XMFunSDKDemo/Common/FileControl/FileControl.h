//
//  FileControl.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/30.
//  Copyright © 2018年 XM. All rights reserved.
//
/****
 *
 *文件管理类 读取本地图片和录像，以及判断录像类型
 *
 ********/
#import "FunMsgListener.h"
@interface FileControl : FunMsgListener
//读取图片文件夹中的图片
- (NSMutableArray *)getLocalImage;

//读取录像文件夹中的录像
- (NSMutableArray *)getLocalVideo;

//判断录像文件类型是不是H265
- (BOOL)getVideoTypeH265:(NSString*)path;
//判断录像文件类型是不是鱼眼视频
- (BOOL)getVideoTypeFish:(NSString*)path;
@end
