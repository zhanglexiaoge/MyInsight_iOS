//
//  MyStringManager.h
//  XMEye
//
//  Created by Megatron on 3/26/15.
//  Copyright (c) 2015 Megatron. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum STR_TYPE
{
    STR_TYPE_UNKNOW,     // 位置类型
    STR_TYPE_IP,         // 字符串为IP
    STR_TYPE_DN,         // 字符串为域名
    STR_TYPE_SN,         // 字符串为序列号
}_STR_TYPE;

@interface MyStringManager : NSObject

+(enum STR_TYPE)getStrType:(NSString *)str;

+(NSString *)getDevSNFromDevIP:(NSString*)devIP;
+(NSString *)getDevIPFromDevSN:(NSString*)devSN;
+(void)updateDevIP_DevSN:(NSString*)devIP  devSN:(NSString*)devSN;

@end