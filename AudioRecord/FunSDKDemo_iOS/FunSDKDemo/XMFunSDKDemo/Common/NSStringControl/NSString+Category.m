//
//  NSString+Category.m
//  MobileVideo
//
//  Created by XM on 2018/4/23.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "NSString+Category.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NSString (Category)

#pragma mark 国际化语言翻译
+ (NSString *)ToNSStr:(const char*)szStr {
    if (szStr == NULL) {
        NSLog(@"Error szStr is null!");
        return @"";
    }
    NSString *retStr = [NSString stringWithUTF8String:szStr];
    if (retStr == nil || (retStr.length == 0 && strlen(szStr) > 0)) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData *data = [NSData dataWithBytes:szStr length:strlen(szStr)];
        retStr = [[NSString alloc] initWithData:data encoding:enc];
    }
    if (retStr == nil) {
        retStr = @"";
    }
    return retStr;
}

#pragma mark 是否包含字符串
- (BOOL)isContainsString:(NSString *)sFind {
    if (sFind == nil) {
        return FALSE;
    }
    NSRange range = [self rangeOfString:sFind];
    return range.length != 0;
}

#pragma mark 获取字符串长度
+ (int)countLengthWithString:(NSString *)str {
    int strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

#pragma mark 获得当前网络连接的SSID、IP、Wi-Fi名字
+ (NSString *)getCurrent_SSID {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id infoDic = nil;
    for (NSString *ifnam in ifs) {
        infoDic = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
    }
    const char *charSSID = [[infoDic objectForKey:@"SSID"] UTF8String];
    if (TARGET_IPHONE_SIMULATOR) {
        charSSID = "kuozhanbu";
    }
    if (charSSID == NULL) {
        return @"";
    }
    NSString *ssid = [NSString stringWithUTF8String:charSSID];
    return ssid;
}
+ (NSString *)getCurrent_IP_Address {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}
+ (NSString *)getWifiName {
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

#pragma mark 判断是否是直连设备
+ (BOOL)checkSSID:(NSString*)ssid {
    if ([ssid hasPrefix:@"robot_"] || [ssid hasPrefix:@"card"]|| [ssid hasPrefix:@"car_"]
        || [ssid hasPrefix:@"seye_"] ||[ssid hasPrefix:@"NVR"]|| [ssid hasPrefix:@"DVR"]
        || [ssid hasPrefix:@"beye_"] ||[ssid hasPrefix:@"IPC"]|| [ssid hasPrefix:@"Car_"] || [ssid hasPrefix:@"BOB_"] || [ssid hasPrefix:@"xmjp_"] || [ssid hasPrefix:@"UTEC"] || [ssid hasPrefix:@"camera_"])
    {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 字符串转NSData
+ (NSData *)AutoCopyUTF8Str:(NSString*)string {
    if ([NSString IsChinese:string]) {
        return [NSString UTF8StrToGBKData:string];
    }else{
        return [string dataUsingEncoding:NSUTF8StringEncoding];
    }
}

//汉语字符串转NSData
+ (NSData *)UTF8StrToGBKData:(NSString *)strUTF8 {
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gb2312data = [strUTF8 dataUsingEncoding:encoding];
    return gb2312data;
}
+ (BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)GetSystemTimeString {
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:TimeFormatter];
    NSString *dateString = [dateFormatter stringFromDate:nowDate];
    return dateString;
}

#pragma mark - 保存鱼眼模式
+ (void)saveFisheye:(NSString *)devId mode:(int)fisheyeMode {
    NSString *path = [NSString fisheyeInfoFile];
    NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (!plist) {
        plist = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    NSMutableDictionary *fisheyeDic = plist[devId];//取出该设备的信息
    if (!fisheyeDic) {
        fisheyeDic = [NSMutableDictionary dictionaryWithCapacity:3];
        plist[devId] = fisheyeDic;
    }
    
    fisheyeDic[KFisheyeMode] = [NSString stringWithFormat:@"%d", fisheyeMode];
    
    [plist writeToFile:path atomically:YES];
}

#pragma mark - 读取鱼眼的模式
+ (int)fisheyeMode:(NSString *)devId {
    if ([NSString checkSSID:[NSString getCurrent_SSID]]) {
        return -1;
    }
    NSString *path = [NSString fisheyeInfoFile];
    NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSMutableDictionary *fisheyeDic = plist[devId];
    if (!fisheyeDic) {
        return -1;
    }
    
    NSString* sFisheyeMode = [fisheyeDic valueForKey:KFisheyeMode];
    
    if (sFisheyeMode == nil) {
        return -1;
    } else {
        return [sFisheyeMode intValue];
    }
}

#pragma mark - 取出当前设备是否支持矫正
+(NSString*)getCorrectdev:(NSString*)devId
{
    NSString *path = [NSString correctInfoFile];
    NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (!plist) {
        plist = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return [plist objectForKey:devId];
}

#pragma mark 获取设备网络状态
+ (NSString *)getDeviceNetType:(int)type {
    switch (type) {
        case 0:
            return TS("P2P_Mode");
            break;
        case 1:
            return TS("Transmit_Mode");
            break;
        case 2:
            return TS("IP_Mode");
            break;
        case 5:
            return TS("RPS_Mode");
            break;
        case 6:
            return TS("RTS_P2P");
            break;
        case 7:
            return TS("RTS_Proxy");
            break;
        case 8:
            return TS("P2P_V2");
            break;
        case 9:
            return TS("Proxy_V2");
            break;
        default:
            return TS("no_alarm_type");
            break;
    }
}

#pragma mark 获取设备类型对应的设备图片字符串
+ (NSString *)getDeviceImageType:(int)type {
    NSString *imgString = @"xmjp_seye.png";
    if (type == XM_DEV_DEV) {
        imgString = @"xmjp_camera.png";
    }else if (type == XM_DEV_SOCKET) {
        imgString = @"xmjp_socket.png";
    }else if (type == XM_DEV_BULB) {
        imgString = @"xmjp_bulb.png";
    }else if (type == XM_DEV_BULB_SOCKET) {
        imgString = @"xmjp_bulbsocket.png";
    }else if (type == XM_DEV_CAR) {
        imgString = @"xmjp_car.png";
    }else if (type == XM_DEV_BEYE) {
        imgString = @"xmjp_beye.png";
    }else if (type == XM_DEV_SEYE) {
        imgString = @"xmjp_seye.png";
    }else if (type == XM_DEV_ROBOT) {
        imgString = @"xmjp_rotot.png";
    }else if (type == XM_DEV_SPORT_CAMERA) {
        imgString = @"xmjp_mov.png";
    }else if (type == XM_DEV_FEYE) {
        imgString = @"xmjp_feye.png";
    }else if (type == XM_DEV_FISH_BULB) {
        imgString = @"xmjp_fbulb.png";
    }else if (type == XM_DEV_BOB) {
        imgString = @"xmjp_bob.png";
    }else if (type == XM_DEV_MUSIC_BOX) {
        imgString = @"xmjp_cloudbox_klok.png";
    }else if (type == XM_DEV_INTELLIGENT_CENTER) {
        imgString = @"智联中心";
    }else if (type == XM_DEV_STRIP) {
        imgString = @"插排";
    }else if (type == XM_DEV_DOORLOCK) {
        imgString = @"门磁";
    }else if (type == XM_DEV_CENTER_COPY) {
        imgString = @"智能中心";
    }else if (type == XM_DEV_UFO) {
        imgString = @"飞碟";
    }else if (type == XM_DEV_DOORBELL) {
        imgString = @"智能门铃";
    }else if (type == XM_DEV_BULLET) {
        imgString = @"雄迈枪机";
    }else if (type == XM_DEV_GUNLOCK_510) {
        imgString = @"雄迈枪机";
    }else if (type == XM_DEV_DRUM) {
        imgString = @"架子鼓";
    }else if (type == XM_DEV_FEEDER) {
        imgString = @"喂食器";
    }else if (type == XM_DEV_CAT) {
        imgString = @"猫眼";
    }else if (type == XM_DEV_NSEYE) {
        imgString = @"xmjp_seye.png";
    }else if (type == XM_DEV_INTELLIGENT_LOCK) {
        imgString = @"门铃锁";
    }else if (type == CZ_DOORBELL) {
        imgString = @"创泽门铃";
    }else{
        imgString = @"xmjp_seye.png";
    }
    return imgString;
}

#pragma mark 获取设备类型字符串
+ (NSString *)getDeviceType:(int)type {
    NSString *mDefaultName = TS("Device");
    if (type == XM_DEV_DEV) {
        mDefaultName = TS("传统监控设备");
    }else if (type == XM_DEV_SOCKET) {
        mDefaultName = TS("智能插座");
    }else if (type == XM_DEV_BULB) {
        mDefaultName = TS("情景灯泡");
    }else if (type == XM_DEV_BULB_SOCKET) {
        mDefaultName = TS("智能灯座");
    }else if (type == XM_DEV_CAR) {
        mDefaultName = TS("汽车伴侣");
    }else if (type == XM_DEV_BEYE) {
        mDefaultName = TS("大眼睛");
    }else if (type == XM_DEV_SEYE) {
        mDefaultName = TS("小眼睛");
    }else if (type == XM_DEV_ROBOT) {
        mDefaultName = TS("雄迈摇头机");
    }else if (type == XM_DEV_SPORT_CAMERA) {
        mDefaultName = TS("运动摄像机");
    }else if (type == XM_DEV_FEYE) {
        mDefaultName = TS("鱼眼小雨点");
    }else if (type == XM_DEV_FISH_BULB) {
        mDefaultName = TS("鱼眼灯泡");
    }else if (type == XM_DEV_BOB) {
        mDefaultName = TS("小黄人");
    }else if (type == XM_DEV_MUSIC_BOX) {
        mDefaultName = TS("Wi-Fi音乐盒");
    }else if (type == XM_DEV_INTELLIGENT_CENTER) {
        mDefaultName = TS("智联中心");
    }else if (type == XM_DEV_STRIP) {
        mDefaultName = TS("插排");
    }else if (type == XM_DEV_DOORLOCK) {
        mDefaultName = TS("门磁");
    }else if (type == XM_DEV_CENTER_COPY) {
        mDefaultName = TS("智能中心");
    }else if (type == XM_DEV_UFO) {
        mDefaultName = TS("飞碟");
    }else if (type == XM_DEV_DOORBELL) {
        mDefaultName = TS("智能门铃");
    }else if (type == XM_DEV_BULLET) {
        mDefaultName = TS("雄迈枪机");
    }else if (type == XM_DEV_GUNLOCK_510) {
        mDefaultName = TS("雄迈枪机");
    }else if (type == XM_DEV_DRUM) {
        mDefaultName = TS("架子鼓");
    }else if (type == XM_DEV_FEEDER) {
        mDefaultName = TS("喂食器");
    }else if (type == XM_DEV_CAT) {
        mDefaultName = TS("猫眼");
    }else if (type == XM_DEV_NSEYE) {
        mDefaultName = TS("直播小雨点");
    }else if (type == XM_DEV_INTELLIGENT_LOCK) {
        mDefaultName = TS("门铃锁");
    }else if (type == CZ_DOORBELL) {
        mDefaultName = TS("创泽门铃");
    }else{
        mDefaultName = TS("传统监控设备");
    }
    return mDefaultName;
}

#pragma mark 获取当前设备类型对应的设备图片
+ (NSString*)getDeviceImageNameWithType:(int)type {
    NSString *devTypePath = [[NSBundle mainBundle] pathForResource:@"DeviceType" ofType:@"plist"];
    NSMutableDictionary *devtypeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:devTypePath];
    NSMutableDictionary *deviceDic = [devtypeDic objectForKey:[NSString stringWithFormat:@"%d",type]];
    NSString *imagename = [deviceDic objectForKey:@"Image"];
    if (imagename) {
        return imagename;
    }
    return @"icon_funsdk.png";
}
@end
