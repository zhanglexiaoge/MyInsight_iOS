//
//  PlayCloudVideoViewController.h
//  FunSDKDemo
//
//  Created by XM on 2019/1/8.
//  Copyright © 2019年 XM. All rights reserved.
//
/*****
 *
 * 云视频回放视图控制器，包括下面几部分
 *根据日期查询云视频文件
 *播放云视频文件
 *暂停和恢复录像回放
 *音频控制
 *抓图和录像
 *通过查询到的录像文件显示时间轴，拖动时间轴播放
 *app进入后台时，可以把视频暂停，也可以直接停止，重新唤醒app时，再恢复播放
 *
 *****/
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayCloudVideoViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
