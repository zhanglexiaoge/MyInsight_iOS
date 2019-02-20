//
//  AppDelegate.m
//  XMFamily
//
//  Created by VladDracula on 17-8-4.
//  Copyright (c) 2017年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "FunSDK/FunSDK.h"
#import "FunSDK/netsdk.h"
#import "SDKInitializeModel.h"
#import "DeviceManager.h"
#import "MainViewController.h"

@implementation AppDelegate{
   
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //启动时 注册FunSDK
    [SDKInitializeModel SDKInit];
    //通过第一个参数控制是否打开手机报警推送
    [self canRemoteNotification:YES byFinishLaunchingWithOptions:launchOptions];
    //初始化视图控制器
    [self initRootWindow];
    
    return YES;
}
- (void)initRootWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    //如果自动登录开关打开，自动登录
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    
}

//是否支持报警推送
- (void)canRemoteNotification:(BOOL)open byFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerNotification];
    // 判断是否打开通知
    if([self enableRemoteNotification] == NO) {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0){
        }
    }
    // app关闭 点击通知中心进入 接收通知参数
    NSDictionary *userInfo =[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
    }
    [[LoginShowControl getInstance] setPushFunction:open];
}
// 注册通知
- (void)registerNotification {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // 远程推送
        //ios8注册推送
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        ////// ios8注册推送
        // 1.0创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1";//按钮的标示
        action1.title=TS("Enter");//按钮的标题
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2";
        action2.title=TS("Ignore");
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        // 2.0创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        // 3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        
        // 4.0注册推送
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
}
// 判断是否打开通知
- (BOOL)enableRemoteNotification {
    UIRemoteNotificationType types;
    types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    BOOL ifOpen = types == UIUserNotificationTypeNone ? NO : YES;
    return ifOpen;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"application===程序进入到后台");
  
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

/*
 当从后台挂起状态重新回到前台是调用，比如点击home键之后，重新打开程序的时候
 (一般在该方法中恢复应用程序的数据和状态)
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"application===程序进入到前台");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 推送信息处理
// 注册通知成功 处理方法
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *tokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    tokenStr = [[tokenStr substringFromIndex:1] substringToIndex:71];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[LoginShowControl getInstance] setPushToken:tokenStr];
}

// 注册通知失败 处理方法
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSString *devId = userInfo[@"UUID"];
    DeviceObject *device = [[DeviceControl getInstance]GetDeviceObjectBySN:devId];
    // 强拆 ForceDismantleAlarm=41
    // 如果是门铃设备推送消息 就去刷新一下设备状态
    if (((device.nType == XM_DEV_DOORBELL || device.nType == CZ_DOORBELL || device.nType == XM_DEV_CAT) && [[userInfo objectForKey:@"Event"] intValue] == 30 ) || device.nType == XM_DEV_INTELLIGENT_LOCK || device.nType == XM_DEV_DOORBELL_A || device.nType == XM_DEV_DOORLOCK_V2 ) {
        //获取设备状态
        [[DeviceManager getInstance] getDeviceState:device.deviceMac];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //因为推送具有延时性，并且因为门铃处在被操作阶段，所以过15秒之后多获取一次保证状态正确
            [[DeviceManager getInstance] getDeviceState:device.deviceMac];
        });
    }
    
    NSString *message = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //程序运行期间受到报警信息
        NSLog(@"%@",message);
    });
}
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
    completionHandler();//处理完消息，最后一定要调用这个代码块
}

@end
