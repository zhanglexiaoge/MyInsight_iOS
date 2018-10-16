//
//  ChatContentModel.h
//  MyInsight
//
//  Created by SongMenglong on 2018/3/27.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChatContentModel : NSObject

// 文本
@property (nonatomic, copy) NSString *text;
// 图片尺寸
@property (nonatomic, assign) CGSize picSize;
// 时长
@property (nonatomic, strong) NSString *seconds;
// 文件名
@property (nonatomic, copy) NSString *fileName;
// 语音时长
@property (nonatomic, strong) NSNumber *videoDuration;
// 视频大小
@property (nonatomic, copy) NSString *videoSize;
// 图片大图地址
@property (nonatomic, copy) NSString *bigPicAdress;
// 文件大小
@property (nonatomic, strong) NSString *fileSize;
// 文件类型
@property (nonatomic, copy) NSString *fileType;
// 文件缩略图地址
@property (nonatomic, copy) NSString *fileIconAdress;

@end
