//
//  RecordDataSourse.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/7.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "RecordDataSourse.h"

@implementation RecordDataSourse
#pragma mark - 通过mask值获取对应的录像状态字符串
- (NSString*)getRecordModeString:(int)mask {
    if (mask == 7) { //一直录像
        return [[self getRecordModeArray] objectAtIndex:2];
    }else  if (mask == 6) { //报警录像
        return [[self getRecordModeArray] objectAtIndex:1];
    }else{ //不录像
        return [[self getRecordModeArray] objectAtIndex:0];
    }
}
//通过字符串获取对应的录像mask值
- (NSInteger)getRecordModeMask:(NSString*)maskString{ 
    if ([maskString  isEqualToString:TS("always_record")]) { //一直录像
        return 7;
    }else  if ([maskString  isEqualToString:TS("alarm_record")]) { //报警录像
        return 6;
    }else{ //不录像
        return 0;
    }
}

#pragma mark - 获取各个配置的设置范围
- (NSMutableArray *)getPreRecordArray { //获取预录时间数组 0-30
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i =0; i< 31; i++) {
        NSString *string = [NSString stringWithFormat:@"%d",i];
        [array addObject:string];
    }
    return array;
}
- (NSMutableArray *)getPacketLengthArray { //获取录像时长数组 1-120
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i =1; i< 121; i++) {
        NSString *string = [NSString stringWithFormat:@"%d",i];
        [array addObject:string];
    }
    return array;
}
- (NSArray *)getRecordModeArray { //获取录像状态数组
    NSArray *array = @[TS("never_record"), TS("alarm_record"), TS("always_record")];
    return array;
}
@end
