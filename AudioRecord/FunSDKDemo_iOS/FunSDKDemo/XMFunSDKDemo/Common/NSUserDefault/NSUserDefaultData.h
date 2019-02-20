//
//  NSUserDefaultData.h
//  XMEye
//
//  Created by XM on 2018/4/31.
//  Copyright © 2018年 Megatron. All rights reserved.
//

//是否支持自动登录
#define AUTOLOGIN @"Auto_Login"

////是否是第一次搜索
//#define FIRSTSEARCH @"first_search"
////是否是第一次排序
//#define RANKSECTION @"ranks"
//#define RANK @"rank"
////自动高亮开关
//#define LIGHTABLE @"lightAble"

#import <Foundation/Foundation.h>

@interface NSUserDefaultData : NSObject

//是否支持自动登录
+ (BOOL)ifAutoLogin;
+ (void)autoLoginSave:(BOOL)value;

////是否是第一次搜索排序
//+(BOOL)ifFirstTimeSearchPromet;
//
////是否是第一次排序
//+(BOOL)ifFirstTimeRank;
//
////是否是自动高亮
//+(BOOL)ifAutoLight;
//+(void)autoLightSave:(BOOL)value;


@end
