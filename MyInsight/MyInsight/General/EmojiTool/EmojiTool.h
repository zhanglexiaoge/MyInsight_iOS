//
//  EmojiTool.h
//  MyInsight
//
//  Created by SongMengLong on 2018/6/25.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmojiTool : NSObject

+ (NSString *)emojiStringFromString:(NSString *)text;

+ (NSString *)plainStringFromEmojiString:(NSString *)emojiText;

@end
