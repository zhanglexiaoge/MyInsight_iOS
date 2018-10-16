
//
//  XieHouYuModel.m
//  MyInsight
//
//  Created by SongMengLong on 2018/7/30.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "XieHouYuModel.h"

@implementation XieHouYuModel

+ (id)modelWithDictionary:(NSDictionary *)dic {
    XieHouYuModel *model = [[XieHouYuModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end
