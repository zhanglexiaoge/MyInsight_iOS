//
//  XieHouYuModel.h
//  MyInsight
//
//  Created by SongMengLong on 2018/7/30.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XieHouYuModel : NSObject
// 歇后语Model
// 谜语
@property (nonatomic, strong) NSString *riddle;
// 回答
@property (nonatomic, strong) NSString *answer;

+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
