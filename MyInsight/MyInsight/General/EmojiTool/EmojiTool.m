//
//  EmojiTool.m
//  MyInsight
//
//  Created by SongMengLong on 2018/6/25.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "EmojiTool.h"
#import "emojis.h"

@implementation EmojiTool

+ (NSDictionary *)emojiTool {
    static NSDictionary *emojiAliases;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emojiAliases = EMOJI_HASH;
    });
    return emojiAliases;
}

+ (NSString *)emojiStringFromString:(NSString *)text {
    return [self convertString:text toEmoji:YES];
}

+ (NSString *)plainStringFromEmojiString:(NSString *)emojiText {
    return [self convertString:emojiText toEmoji:NO];
}

+ (NSString *)convertString:(NSString *)text toEmoji:(BOOL)toEmoji {
    NSMutableString *emojiText = [NSMutableString stringWithString:text];
    
    for (NSString *code in[[EmojiTool emojiTool] allKeys]) {
        NSString *emoji = [EmojiTool emojiTool][code];
        if (toEmoji) {
            [emojiText replaceOccurrencesOfString:code withString:emoji options:NSLiteralSearch range:NSMakeRange(0, emojiText.length)];
        } else {
            [emojiText replaceOccurrencesOfString:emoji withString:code options:NSLiteralSearch range:NSMakeRange(0, emojiText.length)];
        }
    }
    return emojiText;
}

@end
