//
//  XDXRecoder.h
//  XDXPCMToAACDemo
//
//  Created by 小东邪 on 23/03/2017.
//
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface XDXRecorder : NSObject
{
    AudioStreamBasicDescription     dataFormat;
    BOOL                            isRunning;
    // AudioQueue
    AudioQueueRef                   mQueue;
    AudioQueueBufferRef             mBuffers[3];
}

@property (readonly)                BOOL                            isRunning;
@property (readonly)                AudioStreamBasicDescription     dataFormat;
@property (readonly)                AudioQueueRef                   mQueue;
// AudioQueue 队列
- (void)startAudioQueueRecorder;
- (void)stopAudioQueueRecorder;

@end
