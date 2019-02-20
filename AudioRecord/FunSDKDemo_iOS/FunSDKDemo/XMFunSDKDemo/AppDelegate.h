//
//  AppDelegate.h
//  XMFamily
//
//  Created by VladDracula on 18-3-4.
//  Copyright (c) 2018年 ___FULLUSERNAME___. All rights reserved.
//
/***
 
 声明： 开发环境：Macos：10.13.6     Xcode：9.4.1
 1、GitHub下载的代码supporting/library文件夹中FunSDK.Framework可能是残缺的，可以去开放平台上面下载最新的FunSDK.Framework来替换。  下载地址：http://docs-open.xmeye.net/#/downloadcenter/downloadcenter-FunSDKdowmload 或 https://open.xmeye.net
 2、如果想要简单快速开发，并且没有定制服务器和其他特殊的功能，那么可以直接重新开发ViewController，按照demo中的       调用方式直接调用各个功能的Manager和Control等功能类 。
 3、如果有定制服务器和其他特殊功能，则可能需要根据定制内容进行一些修改(例如替换支持定制内容的底层库等等)
 4、如果是demo中没有的功能，首先可以根据协议尝试自己开发，如果无法实现则可以联系我们，由我们来判断是否需要在demo中添加此功能 。

 *****/
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;



@end
