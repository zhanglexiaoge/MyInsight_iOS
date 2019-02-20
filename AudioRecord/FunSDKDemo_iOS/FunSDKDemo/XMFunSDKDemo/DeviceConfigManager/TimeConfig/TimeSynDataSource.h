//
//  TimeSynDataSource.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/12.
//  Copyright © 2018年 XM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeSynDataSource : NSObject

#pragma mark  - 根据获取到的和零时区相差的分钟数，计算当前位于哪一个时区
- (NSString *)parseTimeZone:(int)timeMin;
#pragma mark  - 获取手机当前所在时区
- (int)getSystemTimeZone;
#pragma mark  - 获取手机当前时间
- (NSString*)getSystemTimeString;

#pragma mark  - 获取夏令时开始时间
+(NSArray *)getDayLightSavingBeginTime;
#pragma mark  - 获取夏令时结束时间
+(NSArray *)getDayLightSavingEndTime;
@end
