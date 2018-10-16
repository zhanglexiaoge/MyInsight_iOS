//
//  OpenCVVC.h
//  MyInsight
//
//  Created by SongMenglong on 2018/1/2.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <opencv2/opencv.hpp>
//#import "opencv2/highgui/ios.h"
#import "BaseVC.h"

@interface OpenCVVC : BaseVC
{
//    cv::Mat cvImage;
}

@end

/*
 [OpenCV iOS开发（一）——安装](https://www.jianshu.com/p/79f9c4200b9e)
 
 1.安装：
 官网下载opencv2.framework添加到工程;
 官网地址：https://opencv.org/releases.html
 opencv目前分为两个版本系列：opencv2.4.x和opencv3.x。
 简单点说，opencv3.x是一个阉割后的版本（当然，官方的说法是把原来的C变得更加C++化了），
 大多数你能搜到的API都是opencv2.4.x系列的，这些API在opencv3.x往往是不支持的，而且opencv3.x把重要的nonfree模块去掉了。
 
 2.添加依赖库
 libc++.tbd
 AVFoundation.framework
 CoreImage.framework
 CoreGraphics.framework
 QuartzCore.framework
 Accelerate.framework
 如果需要摄像头做视频处理,还需要添加下面两个依赖库：
 CoreVideo.framework
 CoreMedia.framework
 AssetsLibrary.framework
 
 DEMO代码 https://github.com/Itseez/opencv_for_ios_book_samples
 
 ########## [如何从零开始搭建openCV IOS 工程](http://blog.csdn.net/x32sky/article/details/51649554)
 build如果发现编译不过，出现了一个很蛋疼的错误缺少一个libjpg库
 http://sourceforge.net/projects/libjpeg-turbo/files/1.4.0/
 下载 libjpeg-turbo-1.4.0.dmg
 安装这个库，然后你会在路径/opt/libjpeg-turbo/lib找到它libjpeg.a
 打开终端输入 lipo -info /opt/libjpeg-turbo/lib/libjpeg.a 看是不是armv7 x86-64都全，然后把这个.a拷贝到你的工程目录下
 
 #######
 list file not found
 使用OpenCV的文件.m改成.mm
 
 ###### "_OBJC_CLASS_$_MKMapView", referenced from:
 [iOS学习之Map,定位，标记位置的使用](http://www.cnblogs.com/songfeixiang/p/3733682.html)
 添加对应的FrameWork
 */

/*
 [突破github的100M单个大文件上传限制](http://blog.csdn.net/tyro_java/article/details/53440666)
 */


