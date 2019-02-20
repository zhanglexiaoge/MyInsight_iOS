//
//  NSString+Path.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/5.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)

#pragma mark - 鱼眼模式保存的路径
+ (NSString *)fisheyeInfoFile {
    NSString *SSIDinfoFile = [[NSString configFilePath] stringByAppendingString:@"fisheyeInfo.plist"];
    return SSIDinfoFile;
}

#pragma mark - 是否支持视频矫正保存的路径
+ (NSString *)correctInfoFile
{
    NSString *SSIDinfoFile = [[NSString configFilePath] stringByAppendingString:@"correctInfo.plist"];
    return SSIDinfoFile;
}
#pragma mark - 配置文件保存的路径
+ (NSString *)configFilePath {
    NSString *configFilePath = [[NSString cachesPath] stringByAppendingString:@"/Configs/"];
    [NSString checkDirectoryExist:configFilePath];
    return configFilePath;
}

#pragma mark -- 保存的图片路径
+ (NSString *)pictureFilePath {
    NSString *file = [self getPhotoPath];
    NSString *filePath = [file stringByAppendingPathComponent:picturePlist];
    return filePath;
}

#pragma mark - 生成一个设备缩略图文件名
+ (NSString *)devThumbnailFile:(NSString*)devId andChannle:(int)channle {
    NSString *devThumbnailFile = [[NSString devThumbnailPath] stringByAppendingFormat:@"/%@_%d.jpg",devId,channle];
    return devThumbnailFile;
}

#pragma mark - 设备列表中的设备缩略图
+ (NSString *)devThumbnailPath {
    NSString *devThumbnailPath = [[NSString thumbnailPath] stringByAppendingString:@"/Device"];
    [NSString checkDirectoryExist:devThumbnailPath];
    return devThumbnailPath;
}

#pragma mark - 缩略图路径，包括设备缩略图，app手动录像缩略图，设备上图片，录像缩略图.以及报警历史缩略图
+ (NSString *)thumbnailPath {
    NSString *thumbnailPath = [[NSString getPhotoPath] stringByAppendingString:@"/Thumbnail"];
    [NSString checkDirectoryExist:thumbnailPath];
    return thumbnailPath;
}

#pragma mark - 报警历史图片
+ (NSString *)alarmMessagePicPath {
    NSString *alarmMessagePicPath = [[NSString getPhotoPath] stringByAppendingString:@"/AlarmMessagePic"];
    [NSString checkDirectoryExist:alarmMessagePicPath];
    return alarmMessagePicPath;
}

#pragma mark - 所有图片的保存总路径
+ (NSString *)getPhotoPath {
    NSString *photosPath = [[NSString documentsPath] stringByAppendingString:@"/Photos"];
    [NSString checkDirectoryExist:photosPath];
    return photosPath;
}
#pragma mark - 存储录像的路径
+(NSString *)getVideoPath {
    NSString *file = [NSString cachesPath];
    return [NSString getVideoPathString:file];
}

+ (NSString *)getVideoPathString:(NSString *)file {
    file = [file stringByAppendingPathComponent:@"Video"];
    return [NSString checkDirectoryExist:file];
}
// NSDocument/fileName
+ (NSString *)GetDocumentPathWith:(NSString *) fileName {
    NSString* path = [NSString documentsPath];
    if (fileName != nil) {
        path = [path stringByAppendingString:@"/"];
        path = [path stringByAppendingString:fileName];
    }
    return path;
}
+ (NSString *)GetCachesPathWith:(NSString *) fileName {
    NSString *path = [NSString cachesPath];
    if (fileName != nil) {
        path = [path stringByAppendingString:@"/"];
        path = [path stringByAppendingString:fileName];
    }
    return path;
}
//判断当前文件夹是否存在
+(NSString*)checkDirectoryExist:(NSString*)file{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL ifExist = [manager fileExistsAtPath:file isDirectory:&isDir];
    if (!(isDir && ifExist)) {
        BOOL create = [manager createDirectoryAtPath:file withIntermediateDirectories:YES attributes:nil error:nil];
        if (!create) {
        }
    }
    return file;
}
//NSDocument
+ (NSString *)documentsPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray lastObject];
    return path;
}
+ (NSString *)cachesPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray lastObject];
    return path;
}
@end
