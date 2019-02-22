//
//  EYRecord.h
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/2/22.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EYRecord : NSObject

//开始录音
- (void)startRecording;

//停止录音
- (void)stopRecording;

@end

NS_ASSUME_NONNULL_END
