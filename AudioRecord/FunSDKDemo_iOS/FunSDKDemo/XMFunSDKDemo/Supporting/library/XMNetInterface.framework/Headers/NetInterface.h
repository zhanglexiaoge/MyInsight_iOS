//
//  NSString+DealInternet.h
//  XMFamily
//
//  Created by Megatron on 9/12/14.
//  Copyright (c) 2014 Megatron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#define N_RESOLUTION_COUNT 19

@interface NetInterface :NSObject

//获取当前wifi的SSID
+(id)fetchSSIDInfo;

// 获得当前网络连接的ip
+(NSString *)getCurrent_IP_Address;
// 获得当前wifi设备的ssid
+(NSString *)getCurrent_SSID;
+(NSString *)getCurrent_Mac;//获取当前wifi Mac地址
+(BOOL)enableToConnectNetwork;
+(NSString *)getDefaultGateway;

@end
