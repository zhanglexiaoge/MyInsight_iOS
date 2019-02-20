//
//  XMDownloadResource.h
//  XWorld
//
//  Created by DingLin on 17/2/9.
//  Copyright © 2017年 xiongmaitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLouldVideoResource : NSObject <NSCoding>


typedef NS_ENUM(NSInteger, DownloadState) {
    DownloadStateNot,
    DownloadStateDownloading,
    DownloadStateCompleted,
};

@property (nonatomic,copy) NSString *indexFile; // 类似ID
@property (nonatomic, copy) NSString *name;//资源名称
@property (nonatomic, copy) NSString *beginDate;//开始日期
@property (nonatomic, copy) NSString *endDate; //结束日期
@property (nonatomic, copy) NSString* beginTime;//开始时间
@property (nonatomic, copy) NSString* endTime;//结束时间
@property (nonatomic, assign) float progress;//资源下载进度
@property (nonatomic,copy) NSString* devId;//设备ID
@property (nonatomic,assign) NSInteger size;//文件大小
@property (nonatomic,copy) NSString* storePath;//存储路径
@property (nonatomic, assign) DownloadState downloadState;//正在下载
@property (nonatomic, copy) NSString *JsonStr;

@property (nonatomic,copy) NSString *compressPicPath;   // 设备相册缩略图路径

//用于缩略图 组成SDK_SYSTEM_TIME这个参数
@property (nonatomic, unsafe_unretained) int year;
@property (nonatomic, unsafe_unretained) int month;
@property (nonatomic, unsafe_unretained) int day;
@property (nonatomic, unsafe_unretained) int wday;
@property (nonatomic, unsafe_unretained) int hour;
@property (nonatomic, unsafe_unretained) int minute;
@property (nonatomic, unsafe_unretained) int second;
@property (nonatomic, unsafe_unretained) int isdst;//夏令时标识


@end
