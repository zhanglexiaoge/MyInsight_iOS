//
//  NSString+Characters.h
//  MyInsight
//
//  Created by SongMengLong on 2018/6/25.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Characters)

/* 将汉字转换为拼音 */
- (NSString *)pinyinOfName;

/* 汉字转换为拼音后，返回大写的首字母 */
- (NSString *)firstCharacterOfName;

@end
