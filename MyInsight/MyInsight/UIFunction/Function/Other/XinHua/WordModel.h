//
//  WordModel.h
//  MyInsight
//
//  Created by SongMengLong on 2018/7/30.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordModel : NSObject
// 汉字Model

// 字
@property (nonatomic, strong) NSString *word;
// 繁体字
@property (nonatomic, strong) NSString *oldword;
// 笔画数目
@property (nonatomic, assign) NSInteger strokes;
// 拼音
@property (nonatomic, strong) NSString *pinyin;
// 偏旁部首
@property (nonatomic, strong) NSString *radicals;
// 解释释义
@property (nonatomic, strong) NSString *explanation;

+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
