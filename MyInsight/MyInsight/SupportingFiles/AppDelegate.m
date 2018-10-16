//
//  AppDelegate.m
//  MyInsight
//
//  Created by SongMenglong on 2017/11/30.
//  Copyright © 2017年 SongMenglong. All rights reserved.
//

#import "AppDelegate.h"
#import "MainRevealVC.h" // 主页面
#import "WelcomeVC.h" // 欢迎页面
#import <UserNotifications/UserNotifications.h>
#import <SDWebImageDownloader.h>
#import <SDWebImageManager.h>
#import <Flurry.h> // 统计
#import <UMCommon/UMCommon.h> //友盟
//#import <LCChatKit.h>

/*
 友盟API
 5bbc3f6ef1f5569c8300050a
 */

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundUpdateTask;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"FinishLaunchingWithOptions 程序启动完成");
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
    // 注册通知
    [self registerUserNoti];
    // 启动广告
    [self showAdvertiserView];
    // 设置3D Touch功能
    [self setup3DTouch];
    // 是否第一次加载
    [self isRightFirstLaunched];
    // Window可见
    [self.window makeKeyAndVisible];
    // 设置Flurry应用检测
    [self setupFlurry];
    // 友盟
    [self setupUMeng];
    
    return YES;
}

#pragma mark - 是否是第一次加载
- (void)isRightFirstLaunched {
    /*
     若是第一次加载 进入欢迎页面 若不是直接进入主页面
     */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![userDefaults stringForKey:@"LauchAgree"]) {
        // 设置值
        [userDefaults setValue:@"sd" forKey:@"LauchAgree"];
        NSLog(@"第一次启动");
        // 欢迎页
        WelcomeVC *welcomeVC = [[WelcomeVC alloc] init];
        // 设置根视图
        self.window.rootViewController = welcomeVC;
        
    } else {
        MainRevealVC *mainRevealVC = [[MainRevealVC alloc] init];
        // 设置根视图
        self.window.rootViewController = mainRevealVC;
        NSLog(@"不是第一次启动");
    }
}

#pragma mark - 启动广告
- (void)showAdvertiserView {
    NSLog(@"此处 启动 广告！");
}

#pragma mark - 设置Flurry应用检测
- (void)setupFlurry {
    [Flurry startSession:@"TQDQRDHJPWRQPN24JR4S"
      withSessionBuilder:[[[FlurrySessionBuilder new]
                           withCrashReporting:YES]
                          withLogLevel:FlurryLogLevelDebug]];
}

#pragma mark - 设置友盟UMeng
- (void)setupUMeng {
    [UMConfigure initWithAppkey:@"5bbc3f6ef1f5569c8300050a" channel:nil];
}

#pragma mark - 下载图片设置
- (void)sdwebImageLoad {
    
    SDWebImageDownloader *imgDownloader = SDWebImageManager.sharedManager.imageDownloader;
    imgDownloader.headersFilter  = ^NSDictionary *(NSURL *url, NSDictionary *headers) {
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        NSString *imgKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
        NSString *imgPath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:imgKey];
        NSDictionary *fileAttr = [fm attributesOfItemAtPath:imgPath error:nil];
        
        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
        
        NSDate *lastModifiedDate = nil;
        
        if (fileAttr.count > 0) {
            if (fileAttr.count > 0) {
                lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
            }
            
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
        
        NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
        lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";
        [mutableHeaders setValue:lastModifiedStr forKey:@"If-Modified-Since"];
        
        return mutableHeaders;
    };

}


#pragma mark - 注册通知
- (void)registerUserNoti {
    // 设置本地通知 https://zjqian.github.io/2017/04/14/localNotification/
    // 使用 UNUserNotificationCenter 来管理通知
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 监听回调事件 设置代理
        center.delegate = self;
        //iOS 10 使用以下方法注册，才能得到授权
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                              }];
        
        // 获取当前的通知设置，UNNotificationSettings 是只读对象，readOnly，只能通过以下方法获取
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"iOS通知的设定：%@", settings);
        }];
        
        NSLog(@"iOS10及以上注册通知");
    } else {
        // Fallback on earlier versions
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound  categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        NSLog(@"iOS10之前的版本");
    }
}

#pragma mark - 设置3Dtouch功能
- (void)setup3DTouch {
    // 3DTouch实用演练 http://www.sohu.com/a/200417763_208051
    UIApplicationShortcutIcon *homeIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
    UIApplicationShortcutItem *homeItem = [[UIApplicationShortcutItem alloc] initWithType:@"homeAnchor" localizedTitle:@"首页" localizedSubtitle:@"" icon:homeIcon userInfo:nil];
    
    UIApplicationShortcutIcon *playIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay];
    UIApplicationShortcutItem *playItem = [[UIApplicationShortcutItem alloc] initWithType:@"playAnchor" localizedTitle:@"播放" localizedSubtitle:@"" icon:playIcon userInfo:nil];
    
    UIApplicationShortcutIcon *userIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutItem *userItem = [[UIApplicationShortcutItem alloc] initWithType:@"userAnchor" localizedTitle:@"用户" localizedSubtitle:@"" icon:userIcon userInfo:nil];
    
    // UIApplicationShortcutIconTypeShare
    UIApplicationShortcutIcon *shareIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    UIApplicationShortcutItem *shareItem = [[UIApplicationShortcutItem alloc] initWithType:@"shareAnchor" localizedTitle:@"用户" localizedSubtitle:@"" icon:shareIcon userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[homeItem, playItem, userItem, shareItem];
}

// 3D Touch响应
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    // 3D Touch
    if ([shortcutItem.type isEqualToString:@"homeAnchor"]) {
        NSLog(@"主页页面");
    }
    if ([shortcutItem.type isEqualToString:@"playAnchor"]) {
        NSLog(@"播放页面");
    }
    if ([shortcutItem.type isEqualToString:@"userAnchor"]) {
        NSLog(@"个人用户");
    }
    if ([shortcutItem.type isEqualToString:@"shareAnchor"]) {
        NSLog(@"分享用户啊");
    }
}

#pragma mark - 横竖屏切换
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.isSupportHori) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"WillResignActive 程序将要进入后台");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"DidEnterBackground 程序进入后台");
    [self beingBackgroundUpdateTask];
    [self endBackgroundUpdateTask];
}

- (void)beingBackgroundUpdateTask {
//    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"" expirationHandler:^{
//
//    }];
}

- (void)endBackgroundUpdateTask {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"WillEnterForeground 程序将要进入前台");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"DidBecomeActive 程序进入前台");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"WillTerminate 程序退出");
}


@end
