//
//  TimeSynDataSource.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/12.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "TimeSynDataSource.h"

@implementation TimeSynDataSource

#pragma mark - 根据获取到的和零时区相差的分钟数，计算当前位于哪一个时区
-(NSString *)parseTimeZone:(int)timeMin{
    NSString *content = @"";
    if (timeMin  <= 0) {
        int value = abs(timeMin);
        int f = value / 60;
        
        NSString *temp = [NSString stringWithFormat:@"%i",f];
        if (value % 60 == 15){
            temp = [temp stringByAppendingFormat:@".25"];
        }
        else if (value % 60 == 30){
            temp = [temp stringByAppendingFormat:@".5"];
        }
        else if (value % 60 == 45){
            temp = [temp stringByAppendingFormat:@".75"];
        }
        content = [content stringByAppendingFormat:@"%@%@(%@)",TS("East"),temp,TS("Area")];
    }
    else if (timeMin > 0){
        int value = timeMin;
        int f = value / 60;
        
        NSString *temp = [NSString stringWithFormat:@"%i",f];
        if (value % 60 == 15){
            temp = [temp stringByAppendingFormat:@".25"];
        }
        else if (value % 60 == 30){
            temp = [temp stringByAppendingFormat:@".5"];
        }
        else if (value % 60 == 45){
            temp = [temp stringByAppendingFormat:@".75"];
        }
        content = [content stringByAppendingFormat:@"%@%@(%@)",TS("West"),temp,TS("Area")];
    }
    else{
        content = [content stringByAppendingFormat:@"0(%@)",TS("Zone")];
    }
    return content;
}
#pragma mark - 获取手机当前所在时区
- (int)getSystemTimeZone {
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    // 判断是否是夏令时
    NSDate *dateNow = [NSDate date];
    BOOL isDaylightSavingTime = [timeZone isDaylightSavingTimeForDate:dateNow];
    
    [NSTimeZone resetSystemTimeZone]; // 重置手机系统的时区
    NSInteger offset = [NSTimeZone localTimeZone].secondsFromGMT;
    float value = offset/3600.0;
    
    if (isDaylightSavingTime) {
        value--;
    }
    value = -value;
    int myTime = (int)(value * 60);
    return myTime;
}
#pragma mark  - 获取手机当前时间
- (NSString*)getSystemTimeString {
    time_t now = time(NULL);
    struct tm *pNow = localtime(&now);
    NSString *timeString = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",
                            pNow->tm_year + 1900,
                            pNow->tm_mon + 1,
                            pNow->tm_mday,
                            pNow->tm_hour,
                            pNow->tm_min,
                            pNow->tm_sec];
    //上面的时间格式 例如：2018-11-02 19:20:56
    char szParam[128] = {0};
    sprintf(szParam, "{\"Name\":\"OPTimeSetting\",\"OPTimeSetting\":\"%s\"}",SZSTR(timeString));
    return NSSTR(szParam);
}
#pragma mark  - 获取夏令时开始时间
+(NSArray *)getDayLightSavingBeginTime{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    NSDateFormatter *formaterYMD = [[NSDateFormatter alloc] init];
    formaterYMD.dateFormat = @"yyyy-MM-dd";
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formaterYear = [[NSDateFormatter alloc] init];
    formaterYear.dateFormat = @"yyyy";
    
    int bYear = 0,bMonth = 0,bDay = 0;
    NSString *strYear = [formaterYear stringFromDate:date];
    // 遍历查找当前时区下的夏令时范围
    for (int m = 1; m < 12; m++) {
        for (int d = 1 ; d < 31; d++) {
            NSString *ymd = [NSString stringWithFormat:@"%@-%@%i-%@%i",strYear,m >= 10 ? @"" : @"0",m,d >= 10 ? @"" : @"0",d];
            
            NSDate *dateBegin = [formaterYMD dateFromString:ymd];
            
            if ([timeZone isDaylightSavingTimeForDate:dateBegin]) {
                bYear = [strYear intValue];
                bMonth = m;
                bDay = d;
                
                return @[[NSNumber numberWithInt:bYear],[NSNumber numberWithInt:bMonth],[NSNumber numberWithInt:bDay]];
            }
        }
    }
    
    return @[[NSNumber numberWithInt:bYear],[NSNumber numberWithInt:bMonth],[NSNumber numberWithInt:bDay]];
}

#pragma mark  - 获取夏令时结束时间
+(NSArray *)getDayLightSavingEndTime{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    NSDateFormatter *formaterYMD = [[NSDateFormatter alloc] init];
    formaterYMD.dateFormat = @"yyyy-MM-dd";
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formaterYear = [[NSDateFormatter alloc] init];
    formaterYear.dateFormat = @"yyyy";
    
    int eYear = 0,eMonth = 0,eDay = 0;
    NSString *strYear = [formaterYear stringFromDate:date];
    // 遍历查找当前时区下的夏令时范围
    for (int m = 12; m > 1; m--) {
        for (int d = 31 ; d > 1; d--) {
            NSString *ymd = [NSString stringWithFormat:@"%@-%@%i-%@%i",strYear,m >= 10 ? @"" : @"0",m,d >= 10 ? @"" : @"0",d];
            
            NSDate *dateBegin = [formaterYMD dateFromString:ymd];
            
            if ([timeZone isDaylightSavingTimeForDate:dateBegin]) {
                eYear = [strYear intValue];
                eMonth = m;
                eDay = d;
                
                return @[[NSNumber numberWithInt:eYear],[NSNumber numberWithInt:eMonth],[NSNumber numberWithInt:eDay]];
            }
        }
    }
    
    return @[[NSNumber numberWithInt:eYear],[NSNumber numberWithInt:eMonth],[NSNumber numberWithInt:eDay]];
}
@end
