//
//  XDXRecoder.m
//  XDXPCMToAACDemo
//
//  Created by 小东邪 on 23/03/2017.
//
//

#import "XDXRecoder.h"
#import <AudioToolbox/AudioToolbox.h>

#pragma mark - AudioQueue
static void inputBufferHandler(void *                                 inUserData,
                               AudioQueueRef                          inAQ,
                               AudioQueueBufferRef                    inBuffer,
                               const AudioTimeStamp *                 inStartTime,
                               UInt32                                 inNumPackets,
                               const AudioStreamPacketDescription*	  inPacketDesc) {
    XDXRecorder *recoder        = (__bridge XDXRecorder *)inUserData;
    
    NSLog(@"语音输出.... %@", recoder);
//    NSLog(@"%@")
    char * srcData = (char *) inBuffer->mAudioData;
    int dataSize = inBuffer->mAudioDataByteSize;
    NSLog(@"%s %d", srcData, dataSize);
    
    [recoder processAudioBuffer:inBuffer withQueue:inAQ];
    
    // 出队
    AudioQueueRef queue = recoder.mQueue;
    if (recoder.isRunning) {
        AudioQueueEnqueueBuffer(queue, inBuffer, 0, NULL);
    }
}

@implementation XDXRecorder

@synthesize isRunning;
@synthesize dataFormat;
@synthesize mQueue;

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
    
    NSLog(@"starup PCM audio encoder");
    
    memset(&dataFormat, 0, sizeof(dataFormat));
    
    UInt32 size = sizeof(dataFormat.mSampleRate);
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate, &size, &dataFormat.mSampleRate);
    dataFormat.mSampleRate = 48000.0;
    
    size = sizeof(dataFormat.mChannelsPerFrame);
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels, &size, &dataFormat.mChannelsPerFrame);
    
    dataFormat.mFormatID = kAudioFormatLinearPCM;
    dataFormat.mChannelsPerFrame = 1;
    
    dataFormat.mFormatFlags     = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    dataFormat.mBitsPerChannel  = 16;
    dataFormat.mBytesPerPacket  = dataFormat.mBytesPerFrame = (dataFormat.mBitsPerChannel / 8) * dataFormat.mChannelsPerFrame;
    dataFormat.mFramesPerPacket = 1; // 用AudioQueue采集pcm需要这么设置
    
    OSStatus status          = 0;
//    UInt32   size            = sizeof(dataFormat);
    
    status =  AudioQueueNewInput(&dataFormat, inputBufferHandler, (__bridge void *)(self), NULL, NULL, 0, &mQueue);
    NSLog(@"AudioQueueNewInput status:%d",(int)status);
    if (status != noErr) {
        NSLog(@"AudioQueueNewInput Failed status:%d",(int)status);
    }
    
    status = AudioQueueGetProperty(mQueue, kAudioQueueProperty_StreamDescription, &dataFormat, &size);
    NSLog(@"AudioQueueNewInput status:%u",(unsigned int)dataFormat.mFormatID);
    
    for (int i = 0; i != 3; i++) {
        status = AudioQueueAllocateBuffer(mQueue, 512*2*dataFormat.mChannelsPerFrame, &mBuffers[i]);
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
        
        if (stopRes == noErr){
            for (int i = 0; i < 3; i++)
                AudioQueueFreeBuffer(mQueue, mBuffers[i]);
        }else{
        }
        
        AudioQueueDispose(mQueue, true);
        mQueue = NULL;
    }
}


- (void)processAudioBuffer:(AudioQueueBufferRef)buffer withQueue:(AudioQueueRef)queue {
}

- (void)dealloc {
    [super dealloc];
}

@end
