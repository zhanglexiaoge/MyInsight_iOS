//
//  NSString+Category.h
//  MobileVideo
//
//  Created by XM on 2018/4/23.
//  Copyright © 2018年 XM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
#pragma mark 国际化语言翻译
+ (NSString *)ToNSStr:(const char*)szStr;
#pragma mark 是否包含字符串
- (BOOL)isContainsString:(NSString *)sFind;
#pragma mark 字符串长度
+ (int)countLengthWithString:(NSString *)str;

#pragma mark 字符串转NSData
+ (NSData *)AutoCopyUTF8Str:(NSString *)string;

#pragma mark  获得当前网络连接的SSID、IP、Wi-Fi名字
+ (NSString *)getCurrent_SSID;
+ (NSString *)getCurrent_IP_Address;
+ (NSString *)getWifiName;
#pragma mark  判断是否为直连的特殊设备
+ (BOOL)checkSSID:(NSString *)ssid;

#pragma mark 获取时间字符串
+ (NSString *)GetSystemTimeString;

#pragma mark - 读取鱼眼的模式
+ (int)fisheyeMode:(NSString *)devId;
#pragma mark - 保存鱼眼模式
+ (void)saveFisheye:(NSString *)devId mode:(int)fisheyeMode;

#pragma mark - 取出当前设备是否支持矫正
+(NSString*)getCorrectdev:(NSString*)devId;

#pragma mark 获取设备类型对应的设备图片字符串
+ (NSString *)getDeviceImageType:(int)type;

#pragma mark 获取设备类型字符串
+ (NSString *)getDeviceType:(int)type;

#pragma mark 获取当前设备类型对应的设备图片
+ (NSString*)getDeviceImageNameWithType:(int)type;

#pragma mark 获取设备网络状态
+ (NSString *)getDeviceNetType:(int)type;

#pragma mark 获取当前的时间字符串

@end
