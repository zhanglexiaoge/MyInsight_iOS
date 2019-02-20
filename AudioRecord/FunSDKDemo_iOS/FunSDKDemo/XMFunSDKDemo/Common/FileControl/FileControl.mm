//
//  FileControl.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/30.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "FileControl.h"

@implementation FileControl

- (NSMutableArray *)getLocalImage {
    NSString *path = [NSString getPhotoPath];
    NSMutableArray *imageList = (NSMutableArray*)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    if (!imageList) {
        return [NSMutableArray array];
    }
    for (int i =(int)imageList.count-1; i>=0; i--) {
        NSString *imagePath = [imageList objectAtIndex:i];
        if (![imagePath  containsString:@"jpg"]) {
            [imageList removeObjectAtIndex:i];
        }else{
            [imageList replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@/%@",path,imagePath]];
        }
    }
    return imageList;
}
- (NSMutableArray *)getLocalVideo {
    NSString *path = [NSString getVideoPath];
    NSMutableArray *videoList = (NSMutableArray*)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    if (!videoList) {
        return [NSMutableArray array];
    }
    for (int i =(int)videoList.count-1; i>=0; i--) {
        NSString *videoPath = [videoList objectAtIndex:i];
        if ((![videoPath  containsString:@"mp4"])  && (![videoPath  containsString:@"fvideo"])) {
            [videoList removeObjectAtIndex:i];
        }else{
            [videoList replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@/%@",path,videoPath]];
        }
    }
    return videoList;
}
//判断录像文件类型是不是H265
- (BOOL)getVideoTypeH265:(NSString*)path {
    int videoType = 0;//FUN_MediaGetCodecType([path UTF8String]); //目前版本的底层库暂时不支持，后续版本可能会支持，如果有需要可以直接联系我们
    if (videoType == 3) {
        return YES;
    }
    return NO;
}
//判断录像文件类型是不是鱼眼视频
- (BOOL)getVideoTypeFish:(NSString*)path {
    if ([path containsString:@".fvideo"]) {
        return YES;
    }
    return NO;
}
@end
