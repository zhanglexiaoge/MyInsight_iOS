//
//  SDKInitializeModel.m
//  MobileVideo
//
//  Created by XM on 2018/4/23.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "SDKInitializeModel.h"
#import "FunSDK/FunSDK.h"
@implementation SDKInitializeModel

+ (void)SDKInit {
    //1、初始化底层库语言和国际化语言文件
    [self initLanguage];
    //2、初始化app证书,和云服务有关
    [self initPlatform];
    //3、初始化一些必须的底层配置
    [self configParam];
}


//1、初始化底层库语言和国际化语言文件
+ (void)initLanguage {
    //获取当前系统的语言
    NSString *language = [LanguageManager currentLanguage];
    //初始化底层库语言，底层库只支持汉语和英语
    SInitParam pa;
    pa.nAppType = H264_DVR_LOGIN_TYPE_MOBILE;
    if ([language isContainsString:@"zh"]) {
        strcpy(pa.sLanguage,"zh");
    } else {
        strcpy(pa.sLanguage,"en");
    }
    strcpy(pa.nSource, "xmshop");
    FUN_Init(0, &pa);
    //初始化国际化语言文件，app界面显示语言
    Fun_InitLanguage([[[NSBundle mainBundle] pathForResource:language ofType:@"txt"] UTF8String]);
}

//2、初始化app证书
+ (void)initPlatform {
    FUN_XMCloundPlatformInit(UUID, APPKEY, APPSECRET, MOVECARD);
}
//3、初始化一些必须的底层配置
+ (void)configParam {
    // 初始化相关的参数 必须设置,账号登录成功后设备信息的保存路径+文件
    FUN_SetFunStrAttr(EFUN_ATTR_SAVE_LOGIN_USER_INFO,SZSTR([NSString GetDocumentPathWith:@"UserInfo.db"]));
    
    // 本地设备密码存储文件，必须设置
    FUN_SetFunStrAttr(EFUN_ATTR_USER_PWD_DB, SZSTR([NSString GetDocumentPathWith:@"password.txt"]));
    
    //升级⽂文件存放路径(只是路径，不包含文件名)
    FUN_SetFunStrAttr(EFUN_ATTR_UPDATE_FILE_PATH,SZSTR([NSString GetDocumentPathWith:@""]));
    
    //设置是否可以自动下载设备升级文件, 0不自动下载， 1wifi下自动下载， 2 有网络即自动下载
    FUN_SetFunIntAttr(EFUN_ATTR_AUTO_DL_UPGRADE, 0);//自行选择哪一种，可以动态更改
    
    // 配置文件存放路径(只是路径，不包含文件名)
    FUN_SetFunStrAttr(EFUN_ATTR_CONFIG_PATH,SZSTR([NSString GetDocumentPathWith:@"APPConfigs"]));
    
}
@end
