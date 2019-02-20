//
//  AlarmManager.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/5.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "AlarmManager.h"
#import "FunSDK/Fun_MC.h"

@implementation AlarmManager

+ (instancetype)getInstance {
    static AlarmManager *Manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Manager = [[AlarmManager alloc]init];
    });
    return Manager;
}
- (id)init {
    self = [super init];
    return self;
}

//注册报警功能
- (void)LinkAlarm:(NSString *)deviceMac DeviceName:(NSString *)devName {
    NSString *userName = [[LoginShowControl getInstance] getLoginUserName];
    NSString *psw = [[LoginShowControl getInstance] getLoginPassword];
    MC_LinkDev(self.msgHandle, SZSTR(deviceMac), SZSTR(userName), SZSTR(psw), 0, SZSTR(devName));
}
//注销设备报警通知
- (void)UnlinkAlarm:(NSString *)deviceMac {
    MC_UnlinkDev(self.msgHandle, [deviceMac UTF8String], 0);
}

//推送服务器初始化
- (void)MC_INIT:(const char*)tokenChar {
    const char *userName = NULL;
    const char *password = NULL;
    //根据用户名判断当前时什么登陆方式
    if ([[LoginShowControl getInstance] getLoginType] == loginTypeLocal) {
        userName = [@"XMEye" UTF8String];
        password = [@"XMEye" UTF8String];
    }else{
        userName = [[[LoginShowControl getInstance] getLoginUserName] UTF8String];
        password = [[[LoginShowControl getInstance] getLoginPassword] UTF8String];
    }
    EMSGLANGUAGE language;
    //设置汉语时才是汉语，否则是英语
    NSString *languageStr = [LanguageManager currentLanguage];
    if ([languageStr isEqualToString:@"zh_CN"] || [languageStr isEqualToString:@"zh_TW"]) {
        language = ELG_CHINESE;
    }else{
        language = ELG_ENGLISH;
    }
    SMCInitInfo info = {0};
    STRNCPY(info.token, tokenChar);
    strcpy(info.user, userName);
    strcpy(info.password, password);
    info.language = language;
    
#ifdef DEBUG
    PushType pushType = DevelopmentType;
#else
    PushType pushType = ProductionType;
#endif
    info.appType  =  pushType;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *bundleIdentifiler = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    STRNCPY(info.szAppType, [bundleIdentifiler UTF8String]);
    
    MC_Init(self.msgHandle, &info, 0);
}

#pragma mark - 回调函数
- (void)OnFunSDKResult:(NSNumber *)pParam {
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch (msg->id) {
        case EMSG_MC_LinkDev:
            if (msg->param1 < 0) {
                //注册失败
            }else{
                //注册成功
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(LinkAlarmDelegate:Result:)]) {
                [self.delegate LinkAlarmDelegate:NSSTR(msg->szStr) Result:msg->param1];
            }
            break;
        case EMSG_MC_UnlinkDev:
            if (msg->param1 < 0) {
                //注销失败
            }else{
                //注销成功
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(LinkAlarmDelegate:Result:)]) {
                [self.delegate UnlinkAlarmAlarmDelegate:NSSTR(msg->szStr) Result:msg->param1];
            }
            break;
        default:
            break;
    }
    // 更新本地记录并且注册服务端
}

@end
