//
//  IdiomModel.h
//  MyInsight
//
//  Created by SongMengLong on 2018/7/30.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdiomModel : NSObject
// 成语Model

// 出处
@property (nonatomic, strong) NSString *derivation;
// 示例
@property (nonatomic, strong) NSString *example;
// 解释
@property (nonatomic, strong) NSString *explanation;
// 拼音
@property (nonatomic, strong) NSString *pinyin;
// 词语
@property (nonatomic, strong) NSString *word;
// 缩写形式
@property (nonatomic, strong) NSString *abbreviation;

+ (id)modelWithDictionary:(NSDictionary *)dic;

//- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

/*
 iOS 中model的使用
 https://www.jianshu.com/p/6b71ceabbeed
 */
