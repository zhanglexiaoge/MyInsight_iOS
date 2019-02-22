//
//  QueuePlayer.h
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/2/22.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QUEUE_BUFFER_SIZE 6//队列缓冲个数
#define MIN_SIZE_PER_FRAME 1024 //每帧最小数据长度

NS_ASSUME_NONNULL_BEGIN

@interface QueuePlayer : NSObject

// 定义block属性
@property (nonatomic, copy)void (^recordBack)(NSData *data);
// 开始播放录制的内容
- (void)playerWithData:(NSData *)data;

// 开始录制
- (void)startRecord;
// 开始播放
- (void)startPlay;
// 结束录制
- (void)endRecord;
// 结束播放
- (void)endPlay;


@end

NS_ASSUME_NONNULL_END
