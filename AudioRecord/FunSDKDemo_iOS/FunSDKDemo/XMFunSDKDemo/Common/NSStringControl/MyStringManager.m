//
//  MyStringManager.m
//  XMEye
//
//  Created by Megatron on 3/26/15.
//  Copyright (c) 2015 Megatron. All rights reserved.
//

#import "MyStringManager.h"

@implementation MyStringManager

+(enum STR_TYPE)getStrType:(NSString *)str
{
    enum STR_TYPE myType;
    if (str.length < 3) {
        return STR_TYPE_UNKNOW;
    }
    // 先判断是否为IP
    NSString *regexIP = @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexIP];
    BOOL ifIP = [pred evaluateWithObject:str];
    if (ifIP == YES) {
        myType = STR_TYPE_IP;
        return myType;
    }
    else
    {
        // 判断是否为序列号
        NSString *regexSN = @"[a-f0-9]{16}";
        pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexSN];
        BOOL ifSN = [pred evaluateWithObject:str];
        if (ifSN == YES) {
            myType = STR_TYPE_SN;
            return myType;
        }
        else
        {
            // 判断是否为域名
            NSString *tC1 = [str substringWithRange:NSMakeRange(0, 1)];
            NSString *tC2 = [str substringWithRange:NSMakeRange(str.length - 1, 1)];
            NSRange range = [str rangeOfString:@"."];
            if (range.length > 0 && ![tC1 isEqualToString:@"."] && ![tC2 isEqualToString:@"."]) {
                myType = STR_TYPE_DN;
                return myType;
            }
            else
            {
                myType = STR_TYPE_UNKNOW;
                return myType;
            }
        }

    }
}

+(NSString *)getDevSNFromDevIP:(NSString*)devIP{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *ret = [userDefault stringForKey:[NSString stringWithFormat:@"IP_DEV_%@", devIP]];
    if (ret == nil) {
        ret = devIP;
    }
    return ret;
}

+(NSString *)getDevIPFromDevSN:(NSString*)devSN{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *ret = [userDefault stringForKey:[NSString stringWithFormat:@"DEV_IP_%@", devSN]];
    if (ret == nil) {
        ret = devSN;
    }
    return ret;
}

+(void)updateDevIP_DevSN:(NSString*)devIP  devSN:(NSString*)devSN{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:devSN forKey:[NSString stringWithFormat:@"IP_DEV_%@", devIP]];
    [userDefault setObject:devIP forKey:[NSString stringWithFormat:@"DEV_IP_%@", devSN]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
