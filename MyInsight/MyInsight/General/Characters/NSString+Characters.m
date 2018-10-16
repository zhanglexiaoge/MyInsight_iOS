//
//  NSString+Characters.m
//  MyInsight
//
//  Created by SongMengLong on 2018/6/25.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "NSString+Characters.h"

@implementation NSString (Characters)

/* 将汉字转换为拼音 */
- (NSString *)pinyinOfName {
    NSMutableString * name = [[NSMutableString alloc] initWithString:self];
    
    CFRange range = CFRangeMake(0, 1);
    
    /* 汉字转换为拼音,并去除音调 */
    if ( ! CFStringTransform((__bridge CFMutableStringRef) name, &range, kCFStringTransformMandarinLatin, NO) ||
        ! CFStringTransform((__bridge CFMutableStringRef) name, &range, kCFStringTransformStripDiacritics, NO)) {
        return @"";
    }
    
    return name;
}

/* 汉字转换为拼音后，返回大写的首字母 */
- (NSString *)firstCharacterOfName {
    NSMutableString * first = [[NSMutableString alloc] initWithString:[self substringWithRange:NSMakeRange(0, 1)]];
    
    CFRange range = CFRangeMake(0, 1);
    
    /* 汉字转换为拼音,并去除音调 */
    if ( ! CFStringTransform((__bridge CFMutableStringRef) first, &range, kCFStringTransformMandarinLatin, NO) ||
        ! CFStringTransform((__bridge CFMutableStringRef) first, &range, kCFStringTransformStripDiacritics, NO)) {
        return @"";
    }
    
    NSString * result;
    result = [first substringWithRange:NSMakeRange(0, 1)];
    
    return result.uppercaseString;
}

@end
