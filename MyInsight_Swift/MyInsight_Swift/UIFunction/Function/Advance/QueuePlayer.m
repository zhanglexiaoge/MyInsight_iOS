//
//  QueuePlayer.m
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/2/22.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

#import "QueuePlayer.h"

#import <AVFoundation/AVFoundation.h>

BOOL audioQueueUsed[QUEUE_BUFFER_SIZE];

AudioQueueBufferRef rBuffer[QUEUE_BUFFER_SIZE];
AudioQueueBufferRef pBuffer[QUEUE_BUFFER_SIZE];

@interface QueuePlayer()
{
    AudioQueueRef recordQueue;
    
    AudioQueueRef playQueue;
    
    NSLock *lock;
}

@end

@implementation QueuePlayer

#pragma mark  初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        
        //[[AVAudioSession sharedInstance] setPreferredInputNumberOfChannels:1 error:nil];
        //[[AVAudioSession sharedInstance] setPreferredIOBufferDuration:0.1 error:nil];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
        
        AudioStreamBasicDescription ASBD;
        ASBD.mBitsPerChannel = 16;
        ASBD.mBytesPerFrame = 2;
        ASBD.mBytesPerPacket = 2;
        ASBD.mChannelsPerFrame = 1;
        ASBD.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        ASBD.mFormatID = kAudioFormatLinearPCM;
        ASBD.mFramesPerPacket = 1;
        ASBD.mSampleRate = 8000;
        
        // 播放队列
        AudioQueueNewOutput(&ASBD, OutputCallback, (__bridge void * _Nullable)(self), nil, nil, 0, &playQueue);
        // 录制队列
        AudioQueueNewInput(&ASBD, InputCallback, (__bridge void * _Nullable)(self), nil, nil, 0, &recordQueue);
        
        
        for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
            AudioQueueAllocateBuffer(recordQueue, MIN_SIZE_PER_FRAME, rBuffer+i);
            AudioQueueAllocateBuffer(playQueue, MIN_SIZE_PER_FRAME, pBuffer+i);
        }
        
        
    }
    return self;
}

// 开始录制
- (void)startRecord {
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        AudioQueueEnqueueBuffer(recordQueue, rBuffer[i], 0, nil);
    }
    AudioQueueStart(recordQueue, 0);
}

// 停止录制
- (void)endRecord {
    AudioQueueStop(recordQueue, 0);
}

// 开始播放
- (void)startPlay {
    AudioQueueStart(playQueue, 0);
}

// 停止播放
- (void)endPlay {
    AudioQueueStop(playQueue, 0);
}

#pragma mark  播放数据
- (void)playerWithData:(NSData *)data {
    AudioQueueBufferRef theBuffer = NULL;
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        if (audioQueueUsed[i]) {
            continue;
        }
        theBuffer = pBuffer[i];
        audioQueueUsed[i] = YES;
        
        
        memcpy(theBuffer->mAudioData, data.bytes, data.length);
        theBuffer->mAudioDataByteSize = data.length;
        AudioQueueEnqueueBuffer(playQueue, theBuffer, 0, nil);
        break;
    }
}

#pragma mark  输出回调
void OutputCallback(
                    void * __nullable       inUserData,
                    AudioQueueRef           inAQ,
                    AudioQueueBufferRef     inBuffer)
{
    NSLog(@" 输出回调 ");
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        if (inBuffer == pBuffer[i]) {
            audioQueueUsed[i] = NO;
            
            NSLog(@"buff(%d) 使用完成",i);
            break;
            
        }
    }
}

#pragma mark  输入回调
void InputCallback(
                   void * __nullable               inUserData,
                   AudioQueueRef                   inAQ,
                   AudioQueueBufferRef             inBuffer,
                   const AudioTimeStamp *          inStartTime,
                   UInt32                          inNumberPacketDescriptions,
                   const AudioStreamPacketDescription * __nullable inPacketDescs)
{
    
    NSLog(@" 输入回调 ");
    QueuePlayer *player = (__bridge QueuePlayer *)(inUserData);
    [player playWithbuffer:inBuffer];
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil);
}


- (void)playWithbuffer:(AudioQueueBufferRef )buffRef {
    
    NSData *data = [NSData dataWithBytes:buffRef->mAudioData length:buffRef->mAudioDataByteSize];
    if (_recordBack) {
        _recordBack(data);
    }
}

@end
