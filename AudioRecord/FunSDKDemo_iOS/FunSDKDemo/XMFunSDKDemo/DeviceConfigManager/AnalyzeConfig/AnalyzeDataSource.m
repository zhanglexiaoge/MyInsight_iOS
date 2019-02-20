//
//  IntelData.m
//  XMEye
//
//  Created by XM on 2017/5/8.
//  Copyright © 2017年 Megatron. All rights reserved.
//

#import "AnalyzeDataSource.h"

@implementation AnalyzeDataSource
#pragma mark - 根据int获取string
- (NSString *)getAnalyzeTypeString:(NSInteger)type {
    NSArray *array = [self analyzeTypeArray];
    if (type >=0 && type <3) {
        //如果获取到的数据在正常数据范围内
        return array[type];
    }
    //数据异常时也要返回
    return array[0];
}
#pragma mark  根据String获取int
- (NSInteger)getAnalyzeTypeInt:(NSString*)typeString {
    NSArray *array = [self analyzeTypeArray];
    if ([array containsObject:typeString]) {
        return [array indexOfObject:typeString]+1;
    }
    //数据异常时也要返回
    return 0;
}

#pragma mark - 获取开关字符串
-(NSString *)getEnableString:(BOOL)enable {
    NSArray *array = [self getEnableArray];
    return array[enable];
}
#pragma mark  获取开关BOOL值
-(BOOL)getEnableBool:(NSString *)enableStr {
    NSArray *array = [self getEnableArray];
    if ([array containsObject:enableStr]) {
        return [array indexOfObject:enableStr];
    }
    return NO;
}
- (NSArray *)analyzeLevelArray {
    NSArray *array = @[TS("1"), TS("2"), TS("3"), TS("4"), TS("5")];
    return array;
}
- (NSArray *)analyzeTypeArray {
    NSArray *array = @[TS("Analyzer_PEA"), TS("Analyzer_OSC"), TS("Analyzer_AVD")];
    return array;
}
- (NSArray *)getEnableArray {
    NSArray *array = @[TS("close"), TS("open")];
    return array;
}
@end
