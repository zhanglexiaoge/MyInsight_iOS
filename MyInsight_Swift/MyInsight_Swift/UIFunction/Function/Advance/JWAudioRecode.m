//
//  JWAudioRecode.m
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/2/20.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

#import "JWAudioRecode.h"

#import <AudioToolbox/AudioToolbox.h>

static const int kNumberBuffers = 3;

// 定义结构体

@interface JWAudioRecode()


@end

@implementation JWAudioRecode



// 开始语音对讲
- (void)startVoiceTalk {
    
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 44100;
    // PCM格式
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mChannelsPerFrame = 1;
    audioFormat.mBitsPerChannel = 16;
    audioFormat.mBytesPerPacket = 2;
    audioFormat.mBytesPerFrame = 2;
    
    AudioFileTypeID fileType= kAudioFileAIFFType;
    audioFormat.mFormatFlags = kLinearPCMFormatFlagIsBigEndian | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    
//    AudioQueueNewInput (&audioFormatt, HandleInputBuffer,&aqData, NULL, kCFRunLoopCommonModes,0,&aqData.mQueue);
//
//    UInt32 dataFormatSize = sizeof (aqData.mDataFormat);
//    AudioQueueGetProperty (aqData.mQueue,kAudioQueueProperty_StreamDescription,&aqData.mDataFormat,&dataFormatSize);
//
//    CFURLRef audioFileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, CFSTR("output.caf"), kCFURLPOSIXPathStyle, false);
//
//    AudioFileCreateWithURL(audioFileURL,fileType, &aqData.mDataFormat, kAudioFileFlags_EraseFile, &aqData.mAudioFile);
//
//    DeriveBufferSize(aqData.mQueue, &aqData.mDataFormat, 0.5,  &aqData.bufferByteSize);
    
    
}

- (void)stopVoiceTalk {
    
}


static void HandleInputBuffer (void                                *aqData,
                               AudioQueueRef                       inAQ,
                               AudioQueueBufferRef                 inBuffer,
                               const AudioTimeStamp                *inStartTime,
                               UInt32                              inNumPackets,
                               const AudioStreamPacketDescription  *inPacketDesc
                               ){
//    AQRecorderState *pAqData = (AQRecorderState *) aqData;
//    if(inNumPackets == 0 && pAqData->mDataFormat.mBytesPerPacket!=0) {
//        inNumPackets = inBuffer->mAudioDataByteSize / pAqData->mDataFormat.mBytesPerPacket;
//    }
//
//    if (AudioFileWritePackets (pAqData->mAudioFile,false,inBuffer->mAudioDataByteSize,inPacketDesc,pAqData->mCurrentPacket,&inNumPackets, inBuffer->mAudioData) == noErr) {
//        pAqData->mCurrentPacket += inNumPackets;
//    }
//    if (pAqData->mIsRunning == 0)
//        return;
//
//    AudioQueueEnqueueBuffer(pAqData->mQueue,inBuffer,0,NULL);
}





@end
