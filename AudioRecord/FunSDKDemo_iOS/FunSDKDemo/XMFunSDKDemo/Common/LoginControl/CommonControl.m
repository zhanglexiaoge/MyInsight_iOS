//
//  CommonControl.m
//  FunSDKDemo
//
//  Created by XM on 2018/10/19.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "CommonControl.h"
#import "sys/utsname.h"

static CommonControl *instance;
@implementation CommonControl
+(id)getInstance
{
    if (instance == nil) {
        instance = [[CommonControl alloc] init];
    }
    return instance;
}
//获取手机信息
- (int)getDeviceString
{
    if (self.iponeVersion != typeNone) {
        return self.iponeVersion;
    }
    //模拟器只能用这种方式
    int height = (int)[UIScreen mainScreen].bounds.size.height;
    if (height == 812) {
        self.iponeVersion = IphoneX;
        return IphoneX;
    }
    //真机可以用下面的方式
    struct utsname systemInfos;
    uname(&systemInfos);
    NSString *platform = [NSString stringWithCString:systemInfos.machine encoding:NSUTF8StringEncoding];
    if ([platform isEqualToString:@"iPhone9,1"] || [platform isEqualToString:@"iPhone9,3"]){
        return Iphone7;
    }else if ([platform isEqualToString:@"iPhone9,2"] || [platform isEqualToString:@"iPhone9,4"]){
        return Iphone7P;
    }else if ([platform isEqualToString:@"iPhone10,1"] || [platform isEqualToString:@"iPhone10,4"]){
        return Iphone8;
    }else if ([platform isEqualToString:@"iPhone10,2"] || [platform isEqualToString:@"iPhone10,5"]){
        return Iphone8P;
    }else if ([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"]){
        return IphoneX;
    }else if([platform isEqualToString:@"iPhone8,1"]){
        self.iponeVersion = Iphone6;
        return Iphone6;
    }else if ([platform isEqualToString:@"iPhone8,2"]){
        self.iponeVersion = Iphone6P;
        return Iphone6P;
    }else if ([platform isEqualToString:@"iPhone7,2"]) {
        self.iponeVersion = Iphone6;
        return Iphone6;
    }else if ([platform isEqualToString:@"iPhone7,1"]) {
        self.iponeVersion = Iphone6P;
        return Iphone6P;
    }else if ([platform isEqualToString:@"iPhone6,1"]||[platform isEqualToString:@"iPhone6,0"]||[platform isEqualToString:@"iPhone6,2"])
    {
        self.iponeVersion = Iphone5;
        return Iphone5;
    }else {
        self.iponeVersion = Iphone4;
        return Iphone4;
    }
}

@end
