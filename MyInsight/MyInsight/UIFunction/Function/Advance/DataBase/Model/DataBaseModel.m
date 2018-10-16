//
//  DataBaseModel.m
//  MyInsight
//
//  Created by SongMenglong on 2018/2/24.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "DataBaseModel.h"

@implementation DataBaseModel

+ (instancetype)contentForCell:(NSDictionary *)dic {
    DataBaseModel *model = [[DataBaseModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
