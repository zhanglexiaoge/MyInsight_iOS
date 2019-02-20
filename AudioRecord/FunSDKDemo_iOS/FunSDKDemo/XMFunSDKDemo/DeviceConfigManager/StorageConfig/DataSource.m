//
//  DataSource.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/18.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource
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

- (NSArray *)getEnableArray {
    NSArray *array = @[TS("close"), TS("open")];
    return array;
}
@end
