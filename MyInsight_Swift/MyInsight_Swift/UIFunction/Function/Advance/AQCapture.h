//
//  AQCapture.h
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/2/22.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 设置代理
@protocol AQCaptureDelegate <NSObject>

- (void)returnData:(NSMutableData *)data;

@end


@interface AQCapture : NSObject
// 代理属性
@property (nonatomic,strong) id<AQCaptureDelegate>delegate;
// 开始录制
- (void)startRecord;
// 停止录制
- (void)stopRecord;

@end

