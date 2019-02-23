//
//  MLRecorder.m
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/2/23.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

#import "MLRecorder.h"
//#import <AudioToolbox/AudioToolbox.h>

#define kXDXRecoderAudioBytesPerPacket      2
#define kXDXRecoderPCMTotalPacket           512
#define kXDXRecoderPCMFramesPerPacket       1
#define kXDXAudioSampleRate                 48000.0
#define kTVURecoderPCMMaxBuffSize           2048

AudioConverterRef               _encodeConvertRef = NULL;   ///< convert param

static int          pcm_buffer_size = 0;
static uint8_t      pcm_buffer[kTVURecoderPCMMaxBuffSize*2];


#pragma mark - AudioQueue
static void inputBufferHandler(void *                                 inUserData,
                               AudioQueueRef                          inAQ,
                               AudioQueueBufferRef                    inBuffer,
                               const AudioTimeStamp *                 inStartTime,
                               UInt32                                 inNumPackets,
                               const AudioStreamPacketDescription*      inPacketDesc) {
    MLRecorder *recoder        = (__bridge MLRecorder *)inUserData;
    
    NSLog(@"语音输出.... ");
    
    // 出队
    AudioQueueRef queue = recoder.mQueue;
    if (recoder.isRunning) {
        AudioQueueEnqueueBuffer(queue, inBuffer, 0, NULL);
    }
}

@interface MLRecorder()

-(void)setUpRecoderWithFormatID:(UInt32) formatID;

-(void)copyEncoderCookieToFile;

@end


@implementation MLRecorder


-(void)copyEncoderCookieToFile {
    // Grab the cookie from the converter and write it to the destination file.
    UInt32 cookieSize = 0;
    OSStatus error = AudioConverterGetPropertyInfo(_encodeConvertRef, kAudioConverterCompressionMagicCookie, &cookieSize, NULL);
    
    if (error == noErr && cookieSize != 0) {
        char *cookie = (char *)malloc(cookieSize * sizeof(char));
        error = AudioConverterGetProperty(_encodeConvertRef, kAudioConverterCompressionMagicCookie, &cookieSize, cookie);
        
        if (error == noErr) {
            error = AudioFileSetProperty(mRecordFile, kAudioFilePropertyMagicCookieData, cookieSize, cookie);
            if (error == noErr) {
                UInt32 willEatTheCookie = false;
                error = AudioFileGetPropertyInfo(mRecordFile, kAudioFilePropertyMagicCookieData, NULL, &willEatTheCookie);
                printf("Writing magic cookie to destination file: %u\n   cookie:%d \n", (unsigned int)cookieSize, willEatTheCookie);
            } else {
                printf("Even though some formats have cookies, some files don't take them and that's OK\n");
            }
        } else {
            printf("Could not Get kAudioConverterCompressionMagicCookie from Audio Converter!\n");
        }
        
        free(cookie);
    }
}


-(void)setUpRecoderWithFormatID:(UInt32)formatID {
    memset(&dataFormat, 0, sizeof(dataFormat));
    
    UInt32 size = sizeof(dataFormat.mSampleRate);
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate,
                            &size,
                            &dataFormat.mSampleRate);
    dataFormat.mSampleRate = kXDXAudioSampleRate;
    
    size = sizeof(dataFormat.mChannelsPerFrame);
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels,
                            &size,
                            &dataFormat.mChannelsPerFrame);
    dataFormat.mFormatID = formatID;
    dataFormat.mChannelsPerFrame = 1;
    
    if (formatID == kAudioFormatLinearPCM) {
        dataFormat.mFormatFlags     = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        dataFormat.mBitsPerChannel  = 16;
        dataFormat.mBytesPerPacket  = dataFormat.mBytesPerFrame = (dataFormat.mBitsPerChannel / 8) * dataFormat.mChannelsPerFrame;
        dataFormat.mFramesPerPacket = kXDXRecoderPCMFramesPerPacket; // 用AudioQueue采集pcm需要这么设置
    }
}

#pragma mark public
#pragma mark------
-(id)init {
    if (self = [super init]) {
        isRunning = NO;
        
    }
    
    return self;
}

#pragma mark - Audio Queue 开始录音
-(void)startAudioQueueRecorder {
    if (isRunning) {
        NSLog(@"Start recorder repeat");
        return;
    }
    
    memset(pcm_buffer, 0, pcm_buffer_size);
    pcm_buffer_size = 0;
    
    NSLog(@"starup PCM audio encoder");
    
    [self setUpRecoderWithFormatID:kAudioFormatLinearPCM];
    
    OSStatus status          = 0;
    UInt32   size            = sizeof(dataFormat);
    
    status =  AudioQueueNewInput(&dataFormat, inputBufferHandler, (__bridge void *)(self), NULL, NULL, 0, &mQueue);
    NSLog(@"AudioQueueNewInput status:%d",(int)status);
    if (status != noErr) {
        NSLog(@"AudioQueueNewInput Failed status:%d",(int)status);
    }
    
    status = AudioQueueGetProperty(mQueue, kAudioQueueProperty_StreamDescription, &dataFormat, &size);
    NSLog(@"AudioQueueNewInput status:%u",(unsigned int)dataFormat.mFormatID);
    
    [self copyEncoderCookieToFile];
    
    for (int i = 0; i != kNumberQueueBuffers; i++) {
        status = AudioQueueAllocateBuffer(mQueue, kXDXRecoderPCMTotalPacket*kXDXRecoderAudioBytesPerPacket*dataFormat.mChannelsPerFrame, &mBuffers[i]);
        status = AudioQueueEnqueueBuffer(mQueue, mBuffers[i], 0, NULL);
    }
    
    isRunning  = YES;
    
    status     =  AudioQueueStart(mQueue, NULL);
    NSLog(@"AudioQueueStart status:%d",(int)status);
}

#pragma mark - 停止队列
-(void)stopAudioQueueRecorder {
    if (isRunning == NO) {
        return;
    }
    
    isRunning = NO;
    if (mQueue) {
        OSStatus stopRes = AudioQueueStop(mQueue, true);
        [self copyEncoderCookieToFile];
        
        if (stopRes == noErr){
            for (int i = 0; i < kNumberQueueBuffers; i++)
                AudioQueueFreeBuffer(mQueue, mBuffers[i]);
        }else{
        }
        
        AudioQueueDispose(mQueue, true);
        AudioFileClose(mRecordFile);
        mQueue = NULL;
    }
    
    if(_encodeConvertRef != NULL) {
        AudioConverterDispose(_encodeConvertRef);
        _encodeConvertRef = NULL;
    }
}

- (void)dealloc {
}

@end
