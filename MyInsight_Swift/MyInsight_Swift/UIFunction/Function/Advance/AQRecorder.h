//
//  AQRecorder.h
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/2/21.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

/* number of buffers used by system */
#define kNumberBuffers    3

/* sample rate */
#define kSR                22050.

/* maximum record buffer size */
#define kMaxRecBufferSize    (UInt32)(kSR * 5.0)

@interface AQRecorder : NSObject {
    
    AudioQueueRef                queue;
    AudioQueueBufferRef            buffers[kNumberBuffers];
    AudioStreamBasicDescription    dataFormat;
    
    UInt32    writePos;
    
    BOOL    playing;
    
@public
    Float64    audioBuffer[kMaxRecBufferSize];
}

-(void)setup;

-(OSStatus)start;
-(OSStatus)stop;

-(void)saveAudioBuffer:(Float64*)buffer:(UInt32)num_samples;

@end


