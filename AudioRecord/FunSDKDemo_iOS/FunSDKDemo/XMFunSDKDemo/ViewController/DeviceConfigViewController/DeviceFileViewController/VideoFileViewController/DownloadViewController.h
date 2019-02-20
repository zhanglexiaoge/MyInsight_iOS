//
//  DownloadViewController.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/15.
//  Copyright © 2018年 XM. All rights reserved.
//
/**
 *录像下载
 *
 *****/
#import <UIKit/UIKit.h>
#import "RecordInfo.h"

@interface DownloadViewController : UIViewController

- (void)startDownloadRecord:(RecordInfo*)recordInfo;
@end
