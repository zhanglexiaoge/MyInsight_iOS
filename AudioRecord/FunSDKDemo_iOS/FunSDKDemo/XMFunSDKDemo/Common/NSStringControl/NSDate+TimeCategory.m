//
//  NSDate+TimeCategory.m
//  XMEye
//
//  Created by XM on 2017/3/2.
//  Copyright © 2017年 Megatron. All rights reserved.
//

#import "NSDate+TimeCategory.h"

static NSDateFormatter *dateFormatter;

@implementation NSDate (TimeCategory)

+(NSDateFormatter *)defaultFormatter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc]init];
    });
    return dateFormatter;
}

+ (NSDate *)dateFromString:(NSString *)timeStr
                    format:(NSString *)format{
    NSDateFormatter *dateFormatter = [NSDate defaultFormatter];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    return date;
}

+ (NSInteger)cTimestampFromDate:(NSDate *)date{
    return (long)[date timeIntervalSince1970];
}


+(NSInteger)cTimestampFromString:(NSString *)timeStr
                          format:(NSString *)format{
    NSDate *date = [NSDate dateFromString:timeStr format:format];
    return [NSDate cTimestampFromDate:date];
}

+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp
                     withDateFormat:(NSString *)format{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    return [NSDate datestrFromDate:date withDateFormat:format];
}

+ (NSString *)datestrFromDate:(NSDate *)date withDateFormat:(NSString *)format {
    NSDateFormatter* dateFormat = [NSDate defaultFormatter];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

//通过传入的时间提取出年月日
+ (int)getYearFormDate:(NSDate*)date{
    NSArray *array = [NSDate getDateAray:date];
    if (array!= nil && array.count==3) {
        return [[array objectAtIndex:0] intValue];
    }
    return 2017;
}
+ (int)getMonthFormDate:(NSDate*)date{
    NSArray *array = [NSDate getDateAray:date];
    if (array!= nil && array.count==3) {
        return [[array objectAtIndex:1] intValue];
    }
    return 1;
}
+ (int)getDayFormDate:(NSDate*)date{
    NSArray *array = [NSDate getDateAray:date];
    if (array!= nil && array.count==3) {
        return [[array objectAtIndex:2] intValue];
    }
    return 1;
}
+ (int)getHourFormDate:(NSDate*)date {
    NSArray *array = [NSDate getTimeAray:date];
    if (array!= nil && array.count==3) {
        return [[array objectAtIndex:0] intValue];
    }
    return 0;
}
+ (int)getMinuteFormDate:(NSDate*)date {
    NSArray *array = [NSDate getTimeAray:date];
    if (array!= nil && array.count==3) {
        return [[array objectAtIndex:1] intValue];
    }
    return 0;
}
+ (int)getSecondFormDate:(NSDate*)date {
    NSArray *array = [NSDate getTimeAray:date];
    if (array!= nil && array.count==3) {
        return [[array objectAtIndex:2] intValue];
    }
    return 0;
}
+(NSArray*)getDateAray:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DateFormatter];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSArray *array = [dateString componentsSeparatedByString:@"-"];
    if (array == nil || array.count <3) {
        array = [NSArray arrayWithObjects:@"2017",@"1",@"1", nil];
    }
    return array;
}
+(NSArray*)getTimeAray:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:TimeFormatter2];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSArray *array = [dateString componentsSeparatedByString:@":"];
    if (array == nil || array.count <3) {
        array = [NSArray arrayWithObjects:@"0",@"0",@"0", nil];
    }
    return array;
}
//NSDate日期比较，是否是同一天，同一月，同一年
+ (BOOL)checkDate:(NSDate*)date1 WithDate:(NSDate*)date2{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}
//获取从1970年到现在的时间数
- (double)getCurrentDateInterval{
    NSDate *senddate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval index = [senddate timeIntervalSince1970] * 1000; //毫秒
    return index;
}
@end
