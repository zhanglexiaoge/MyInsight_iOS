//
//  NSString+Path.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/5.
//  Copyright © 2018年 XM. All rights reserved.
//

NSString * const KFisheyeMode = @"Fisheye_model";
NSString * const picturePlist = @"picture.plist";

#import <Foundation/Foundation.h>

@interface NSString (Path)

//Document 文件夹中直接创建文件
+ (NSString *)GetDocumentPathWith:(NSString *) fileName;
//Caches 文件夹中直接创建文件
+ (NSString *)GetCachesPathWith:(NSString *) fileName;

#pragma mark -- 保存的图片路径plist
+ (NSString *)pictureFilePath;

#pragma mark - 鱼眼模式保存的路径plist
+ (NSString *)fisheyeInfoFile;

#pragma mark - 是否支持视频矫正保存的路径
+ (NSString *)correctInfoFile;

#pragma mark - 缩略图路径，包括设备缩略图，app手动录像缩略图，设备上图片，录像缩略图.以及报警历史缩略图
+ (NSString *)thumbnailPath;
#pragma mark - 报警历史图片
+ (NSString *)alarmMessagePicPath;
#pragma mark - 生成一个设备缩略图文件名
+ (NSString *)devThumbnailFile:(NSString*)devId andChannle:(int)channle;

#pragma mark - 存储录像的路径
+(NSString *)getVideoPath;
#pragma mark - 所有图片的保存总路径
+ (NSString *)getPhotoPath;
@end
