//
//  DataBaseModel.h
//  MyInsight
//
//  Created by SongMenglong on 2018/2/24.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *info;

@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *source;

+ (instancetype)contentForCell:(NSDictionary *)dic;

@end
