//
//  LanguageManager.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/3.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "LanguageManager.h"
#import <FunSDK/FunSDK.h>
@implementation LanguageManager


+ (NSString *)LanguageManager_TS:(const char*)key {
    const char *value;
    value = Fun_TS(key);
    return [self ToNSStr:value];
}
+ ToNSStr:(const char*)szStr {
    if (szStr == NULL) {
        NSLog(@"Error szStr is null!!!!!!!!!!");
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

+ (void)setCurrentLanguage:(NSString *)language {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:language forKey:@"Language_String"];
}
//判断当前语言是不是英语
+ (BOOL)checkSystemCurrentLanguageIsEnglish{
    const NSString *englist = @"en";
    NSString *currentLanguage = [self currentLanguage];
    if ([englist isEqualToString:currentLanguage]) {
        return true;
    }else{
        return false;
    }
}
//判断当前语言是不是汉语
+ (BOOL)checkSystemCurrentLanguageIsSimplifiedChinese{
    const NSArray *languageTargs = @[@"zh_CN"];
    NSString *currentLanguage = [self currentLanguage];
    for (NSString *languageTarg in languageTargs) {
        if ([languageTarg isEqualToString:currentLanguage]) {
            return true;
        }
    }
    
    return false;
}
//根据当前系统语言返回对应的国际化文件
+ (NSString *)currentLanguage {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *languageStr = [userDefaults objectForKey:@"Language_String"];
    NSString *setLan = @"en";
    
    if (languageStr == nil || [languageStr isEqualToString:@"auto"]) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isContainsString:@"zh-Hans"]) {
            setLan = @"zh_CN";
        }//else if ([currentLanguage isContainsString:@"zh-Hant"]) {
//            setLan = @"zh_TW";
//        }else if ([currentLanguage isContainsString:@"ko-"]) {
//            setLan = @"ko_KR";
//        }else if ([currentLanguage isContainsString:@"fr-"] || [currentLanguage isContainsString:@"fr-CA"]){
//            //前面为法文 后面为加拿大法文
//            setLan = @"fr";
//        }else if ([currentLanguage isContainsString:@"tr-"]) {
//            //土耳其语言
//            setLan = @"tr_TR";
//        }else if ([currentLanguage isContainsString:@"ru-"]) {
//            //俄语
//            setLan = @"ru";
//        }else if ([currentLanguage isContainsString:@"pt-PT"] || [currentLanguage isContainsString:@"pt-BR"]) {
//            //前面为葡萄牙 后面为巴西（葡萄牙语言）
//            setLan = @"pt";
//        }else if ([currentLanguage isContainsString:@"it-"]) {
//            //意大利语
//            setLan = @"ita";
//        }else if ([currentLanguage isContainsString:@"es-"] || [currentLanguage isContainsString:@"es-MX"] || [currentLanguage isContainsString:@"es-419"]) {
//            //前面为西班牙 后面为巴西 最后为拉丁美洲（西班牙）
//            setLan = @"es";
//        }else if ([currentLanguage isContainsString:@"de-"]) {
//            //德语
//            setLan = @"ge";
//        }
    }else if ([languageStr isEqualToString:@"english"]){
        setLan = @"en";
    }else if ([languageStr isEqualToString:@"zh_cn"]) {
        setLan = @"zh_CN";
    }//else if ([languageStr isEqualToString:@"zh_tw"]){
//        setLan = @"zh_TW";
//    }else if ([languageStr isEqualToString:@"ko_kr"]){
//        setLan = @"ko_KR";
//    }else if ([languageStr isEqualToString:@"fr"]){
//        setLan = @"fr";//法语
//    }else if ([languageStr isEqualToString:@"tr_TR"]){
//        setLan = @"tr_TR";//土耳其语
//    }else if ([languageStr isEqualToString:@"ru"]){
//        setLan = @"ru";//俄语
//    }else if ([languageStr isEqualToString:@"pt"]){
//        setLan = @"pt";//葡萄牙语
//    }else if ([languageStr isEqualToString:@"ita"]){
//        setLan = @"ita";//意大利语
//    }else if ([languageStr isEqualToString:@"es"]){
//        setLan = @"es";//西班牙语
//    }else if ([languageStr isEqualToString:@"de"]){
//        setLan = @"ge";//德语
//    }
    return setLan;
}
@end
