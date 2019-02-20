//
//  NSDate+TimeCategory.h
//  XMEye
//
//  Created by XM on 2017/3/2.
//  Copyright © 2017年 Megatron. All rights reserved.
//
#import <Foundation/Foundation.h>

#define  DATEFORMATER  @"yyyy-MM-dd"

@interface NSDate (TimeCategory)
/**
 *  字符串转NSDate
 *
 *  @param theTime 字符串时间
 *  @param format  转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return <#return value description#>
 */
+ (NSDate *)dateFromString:(NSString *)timeStr
                    format:(NSString *)format;

/**
 *  NSDate转时间戳
 *
 *  @param date 字符串时间
 *
 *  @return 返回时间戳
 */
+ (NSInteger)cTimestampFromDate:(NSDate *)date;

/**
 *  字符串转时间戳
 *
 *  @param theTime 字符串时间
 *  @param format  转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回时间戳的字符串
 */
+(NSInteger)cTimestampFromString:(NSString *)timeStr
                          format:(NSString *)format;


/**
 *  时间戳转字符串
 *
 *  @param timeStamp 时间戳
 *  @param format    转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp
                     withDateFormat:(NSString *)format;

/**
 *  NSDate转字符串
 *
 *  @param date   NSDate时间
 *  @param format 转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format;

//通过传入的时间提取出年月日
+ (int)getYearFormDate:(NSDate*)date;
+ (int)getMonthFormDate:(NSDate*)date;
+ (int)getDayFormDate:(NSDate*)date;
+ (int)getHourFormDate:(NSDate*)date;
+ (int)getMinuteFormDate:(NSDate*)date;
+ (int)getSecondFormDate:(NSDate*)date;

/**
 *  NSDate日期比较，是否是同一天，同一月，同一年
 *
 */
+ (BOOL)checkDate:(NSDate*)date1 WithDate:(NSDate*)date2;


/**
 *  获取从1970年到现在的时间数
 */
- (double)getCurrentDateInterval;
@end
