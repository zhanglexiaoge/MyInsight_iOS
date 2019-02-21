//
//  JWAudioRecode.m
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/2/20.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

#import "JWAudioRecode.h"

#import <AVFoundation/AVFoundation.h>

#define kNumberAudioQueueBuffers 3  //定义了三个缓冲区
#define kDefaultBufferDurationSeconds 0.1279   //调整这个值使得录音的缓冲区大小为2048bytes
#define kDefaultSampleRate 8000   //定义采样率为8000


// 定义结构体
typedef struct AQRecorderState {
    // 音频流描述对象
    AudioStreamBasicDescription  mDataFormat;
    // 音频队列
    AudioQueueRef                mQueue;
    // 音频缓存
    AudioQueueBufferRef          mBuffers[kNumberAudioQueueBuffers];
    AudioFileID                  mAudioFile;
    UInt32                       bufferByteSize;
    SInt64                       mCurrentPacket;
    bool                         mIsRunning;
} AQRecorderState;


@interface JWAudioRecode()
// 结构体
@property (nonatomic, assign) AudioStreamBasicDescription recordFormat;
@property (nonatomic, assign) Float64 sampleRate;
// 音频队列
@property (nonatomic, assign) AudioQueueRef audioQueue;

@property (nonatomic, assign) int bufferDurationSeconds;

@property (nonatomic, assign) AudioQueueBufferRef audioBuffers;

@end

@implementation JWAudioRecode


// MARK: - 开始录制
+ (void)startRecording {
    
//    self.sampleRate = 8000;
    
    NSError *error = nil;
    //设置audio session的category
    BOOL ret = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];//注意，这里选的是AVAudioSessionCategoryPlayAndRecord参数，如果只需要录音，就选择Record就可以了，如果需要录音和播放，则选择PlayAndRecord，这个很重要
    if (!ret) {
        NSLog(@"设置声音环境失败");
        return;
    }
    //启用audio session
    ret = [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (!ret) {
        NSLog(@"启动失败");
        return;
    }
    
//    _recordFormat.mSampleRate = self.sampleRate;//设置采样率，8000hz
//
//    //初始化音频输入队列
//    AudioQueueNewInput(&_recordFormat, inputBufferHandler, (__bridge void *)(self), NULL, NULL, 0, &_audioQueue); //inputBufferHandler这个是回调函数名
//
//    //计算估算的缓存区大小
//    int frames = (int)ceil(self.bufferDurationSeconds * _recordFormat.mSampleRate);//返回大于或者等于指定表达式的最小整数
//    int bufferByteSize = frames * _recordFormat.mBytesPerFrame;//缓冲区大小在这里设置，这个很重要，在这里设置的缓冲区有多大，那么在回调函数的时候得到的inbuffer的大小就是多大。
//    NSLog(@"缓冲区大小:%d",bufferByteSize);
//
//    //创建缓冲器
//    for (int i = 0; i < kNumberAudioQueueBuffers; i++) {
//        AudioQueueAllocateBuffer(_audioQueue, bufferByteSize, &_audioBuffers[i]);
//        AudioQueueEnqueueBuffer(_audioQueue, _audioBuffers[i], 0, NULL);//将 _audioBuffers[i]添加到队列中
//    }
//
//    // 开始录音
//    AudioQueueStart(_audioQueue, NULL);
//
//    self.isRecording = YES;
}



+ (void)stopRecording {
//    NSLog(@"stop recording out\n");//为什么没有显示
//    if (self.isRecording)
//    {
//        self.isRecording = NO;
//
//        //停止录音队列和移除缓冲区,以及关闭session，这里无需考虑成功与否
//        AudioQueueStop(_audioQueue, true);
//        AudioQueueDispose(_audioQueue, true);//移除缓冲区,true代表立即结束录制，false代表将缓冲区处理完再结束
//        [[AVAudioSession sharedInstance] setActive:NO error:nil];
//
//    }
}




void inputBufferHandler(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime,UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc) {
    NSLog(@"we are in the 回调函数\n");
    JWAudioRecode *recorder = (__bridge JWAudioRecode*)inUserData;
    
    if (inNumPackets > 0) {
        
        NSLog(@"in the callback the current thread is %@\n",[NSThread currentThread]);
//        [recorder processAudioBuffer:inBuffer withQueue:inAQ];    //在这个函数你可以用录音录到得PCM数据：inBuffer，去进行处理了
        
    }
    
//    if (recorder.isRecording) {
//        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
//    }
}















@end
