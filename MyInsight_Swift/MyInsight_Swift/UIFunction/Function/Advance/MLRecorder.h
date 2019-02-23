//
//  MLRecorder.h
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/2/23.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define kNumberQueueBuffers 3

NS_ASSUME_NONNULL_BEGIN

@interface MLRecorder : NSObject
{
    AudioStreamBasicDescription     dataFormat;
    BOOL                            isRunning;
    
    //state for voice memo
    AudioFileID                     mRecordFile;
    
    // AudioQueue
    AudioQueueRef                   mQueue;
    AudioQueueBufferRef             mBuffers[kNumberQueueBuffers];
}

@property (readonly)                BOOL                            isRunning;
@property (readonly)                AudioStreamBasicDescription     dataFormat;
@property (readonly)                AudioQueueRef                   mQueue;
@property (nonatomic ,assign)       AudioFileID                     mRecordFile;

// AudioQueue 队列
- (void)startAudioQueueRecorder;
- (void)stopAudioQueueRecorder;

@end

NS_ASSUME_NONNULL_END
