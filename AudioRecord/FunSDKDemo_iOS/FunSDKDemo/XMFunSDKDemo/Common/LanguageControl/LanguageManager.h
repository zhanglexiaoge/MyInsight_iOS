//
//  LanguageManager.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/3.
//  Copyright © 2018年 XM. All rights reserved.
//
#define TS(x)       [LanguageManager LanguageManager_TS:x]

#import <Foundation/Foundation.h>

@interface LanguageManager : NSObject
//语言国际化
+ (NSString *)LanguageManager_TS:(const char*)key;
//设置默认语言
+ (void)setCurrentLanguage:(NSString *)language;
//判断当前语言是不是英语
+ (BOOL)checkSystemCurrentLanguageIsEnglish;
//判断当前语言是不是汉语
+ (BOOL)checkSystemCurrentLanguageIsSimplifiedChinese;
//根据当前系统语言返回对应的国际化文件
+ (NSString *)currentLanguage;
@end
