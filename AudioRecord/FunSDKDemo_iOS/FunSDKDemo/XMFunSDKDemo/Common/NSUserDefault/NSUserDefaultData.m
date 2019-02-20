//
//  NSUserDefaultData.m
//  XMEye
//
//  Created by XM on 2018/4/31.
//  Copyright © 2018年 Megatron. All rights reserved.
//

#import "NSUserDefaultData.h"

@implementation NSUserDefaultData

//是否支持自动登录
+ (BOOL)ifAutoLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:AUTOLOGIN];
}
+ (void)autoLoginSave:(BOOL)value {
    [NSUserDefaultData boolValueSave:value key:AUTOLOGIN];
}

////是否是第一次搜索
//+(BOOL)ifFirstTimeSearchPromet{
//    if (![NSUserDefaultData boolValueCheck:FIRSTSEARCH]) {
//        //没有找到，就保存一个值
//        [NSUserDefaultData boolValueSave:FIRSTSEARCH];
//        return YES;//第一次
//    }
//    return NO;//不是第一次
//}
////是否是第一次排序
//+(BOOL)ifFirstTimeRank{
//    if ([NSUserDefaultData stringValueCheck:RANKSECTION] == nil) {
//        [NSUserDefaultData stringValueSave:RANK Key:RANKSECTION];
//        return YES;
//    }
//    return NO;
//}
////是否是自动高亮
//+(BOOL)ifAutoLight{
//    return [NSUserDefaultData boolValueCheck:LIGHTABLE];
//}
////设置自动高亮
//+(void)autoLightSave:(BOOL)value{
//    [NSUserDefaultData boolValueSave:value key:LIGHTABLE];
//}

//取出本地保存的值
+ (BOOL)boolValueCheck:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults]  boolForKey:key];
}
+ (NSString *)stringValueCheck:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults]  objectForKey:key];
}
//保存到本地
+ (void)boolValueSave:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
}
+ (void)boolValueSave:(BOOL)value key:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
}
+ (void)stringValueSave:(NSString*)value Key:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}
+ (void)stringValueSave:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:key];
}
@end
