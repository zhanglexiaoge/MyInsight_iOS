//
//  AudioUnitRecord.h
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/2/21.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioUnitRecord : NSObject
{
    AVAudioUnit *_audioUnit;
}
//@property (nonatomic, strong) AVAudioUnit *_audioUnit;

@end

NS_ASSUME_NONNULL_END
