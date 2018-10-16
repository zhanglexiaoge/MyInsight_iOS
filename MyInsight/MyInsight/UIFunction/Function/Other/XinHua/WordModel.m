
//
//  WordModel.m
//  MyInsight
//
//  Created by SongMengLong on 2018/7/30.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "WordModel.h"

@implementation WordModel

+ (id)modelWithDictionary:(NSDictionary *)dic {
    WordModel *model = [[WordModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
