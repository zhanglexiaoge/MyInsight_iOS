//
//  PushMsgVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/2.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "PushMsgVC.h"
#import <Masonry.h>
#import "UIColor+Category.h"
#import <UserNotifications/UserNotifications.h>

@interface PushMsgVC ()
// 远程推送
@property (nonatomic, strong) UIButton *remoteButton;
// 本地推送
@property (nonatomic, strong) UIButton *localButton;

@end

@implementation PushMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推送消息";
    
    // 创建buttons
    [self creatButtonView];
    // 代码约束布局
    [self masonryLayout];
}

- (void)creatButtonView {
    // 远程推送
    self.remoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.remoteButton];
    self.remoteButton.backgroundColor = [UIColor RandomColor];
    [self.remoteButton setTitle:@"远程推送" forState:UIControlStateNormal];
    [self.remoteButton addTarget:self action:@selector(remoteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 本地推送
    self.localButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.localButton];
    self.localButton.backgroundColor = [UIColor RandomColor];
    [self.localButton setTitle:@"本地推送" forState:UIControlStateNormal];
    [self.localButton addTarget:self action:@selector(localButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 远程推送
- (void)remoteButtonAction:(UIButton *)button {
    NSLog(@"远程推送");
}

#pragma mark - 本地推送
- (void)localButtonAction:(UIButton *)button {
    NSLog(@"本地推送");
    /*
     iOS Push的前世今生
     http://weslyxl.coding.me/2018/02/12/2018/2/iOS推送的前世今生/
     */
    
    // 发送通知
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
    
    if (@available(iOS 10.0, *)) {
        //  > 使用 UNUserNotificationCenter 来管理通知-- 单例
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        // > 需创建一个包含待通知内容的 UNMutableNotificationContent 对象，可变    UNNotificationContent 对象，不可变
        //  > 通知内容
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        // > 通知的title
        content.title = [NSString localizedUserNotificationStringForKey:@"iOS10推送的标题" arguments:nil];
        //
        content.subtitle = @"子标题";
        // > 通知的要通知内容
        content.body = [NSString localizedUserNotificationStringForKey:@"======iOS推送的消息体======" arguments:nil];
        // > 通知的提示声音
        content.sound = [UNNotificationSound defaultSound];
        
        //添加通知下拉动作按钮
        NSMutableArray * actionMutableArray = [NSMutableArray array];
        UNNotificationAction * actionA = [UNNotificationAction actionWithIdentifier:@"identifierNeedUnlock" title:@"进入应用" options:UNNotificationActionOptionAuthenticationRequired];
        UNNotificationAction * actionB = [UNNotificationAction actionWithIdentifier:@"identifierRed" title:@"忽略" options:UNNotificationActionOptionDestructive];
        [actionMutableArray addObjectsFromArray:@[actionA,actionB]];
        
        if (actionMutableArray.count > 1) {
            
            UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:@"categoryNoOperationAction" actions:actionMutableArray intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
            [center setNotificationCategories:[NSSet setWithObjects:category, nil]];
            content.categoryIdentifier = @"categoryNoOperationAction";
        }

        
        //  > 通知的延时执行
        //UNTimeIntervalNotificationTrigger   延时推送
        //UNCalendarNotificationTrigger       定时推送
        //UNLocationNotificationTrigger       位置变化推送
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
triggerWithTimeInterval:5 repeats:NO];
        // 建立通知请求
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond" content:content trigger:trigger];
        
        //添加推送通知，等待通知即可！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
        
            // > 可在此设置添加后的一些设置
            // > 例如alertVC。。
        
        
    } else {
        // Fallback on earlier versions
        
        // https://blog.csdn.net/BraveHeartKing/article/details/79355908
        //[iOS开发本地推送](https://www.cnblogs.com/xianfeng-zhang/p/8309252.html)
        
        // 1.创建通知
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        // 2.设置通知的必选参数
        // 设置通知显示的内容
        localNotification.alertBody = @"推送显示的信息";
        // 设置通知的发送时间,单位秒，在多少秒之后推送
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        //解锁滑动时的事件
        localNotification.alertAction = @"XXOOXX";
        //收到通知时App icon的角标
        localNotification.applicationIconBadgeNumber = 0;
        //推送是带的声音提醒，设置默认的字段为UILocalNotificationDefaultSoundName
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        //设置推送自定义声音格式
        //localNotification.soundName = @"文件名.扩展名";
        //循环次数
        localNotification.repeatInterval = kCFCalendarUnitDay;
        // 3.发送通知(根据项目需要使用)
        // 方式一: 根据通知的发送时间(fireDate)发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
}


// iOS之关于使用 UNUserNotificationCenter 的本地通知
// https://blog.csdn.net/wzc10101415/article/details/80306728
/**
 IOS 10的通知   推送消息 支持的音频 <= 5M(现有的系统偶尔会出现播放不出来的BUG)  图片 <= 10M  视频 <= 50M  ，这些后面都要带上格式；
 @param body 消息内容
 @param promptTone 提示音
 @param soundName 音频
 @param imageName 图片
 @param movieName 视频
 @param identifier 消息标识
 */
-(void)pushNotification_IOS_10_Body:(NSString *)body
                         promptTone:(NSString *)promptTone
                          soundName:(NSString *)soundName
                          imageName:(NSString *)imageName
                          movieName:(NSString *)movieName
                         Identifier:(NSString *)identifier {
    //获取通知中心用来激活新建的通知
    UNUserNotificationCenter * center  = [UNUserNotificationCenter currentNotificationCenter];
    
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc]init];
    
    content.body = body;
    //通知的提示音
    if ([promptTone containsString:@"."]) {
        
        UNNotificationSound *sound = [UNNotificationSound soundNamed:promptTone];
        content.sound = sound;
        
    }
    
    __block UNNotificationAttachment *imageAtt;
    __block UNNotificationAttachment *movieAtt;
    __block UNNotificationAttachment *soundAtt;
    
    if ([imageName containsString:@"."]) {
        
        [self addNotificationAttachmentContent:content attachmentName:imageName options:nil withCompletion:^(NSError *error, UNNotificationAttachment *notificationAtt) {
            
            imageAtt = [notificationAtt copy];
        }];
    }
    
    if ([soundName containsString:@"."]) {
        
        
        [self addNotificationAttachmentContent:content attachmentName:soundName options:nil withCompletion:^(NSError *error, UNNotificationAttachment *notificationAtt) {
            
            soundAtt = [notificationAtt copy];
            
        }];
        
    }
    
    if ([movieName containsString:@"."]) {
        // 在这里截取视频的第10s为视频的缩略图 ：UNNotificationAttachmentOptionsThumbnailTimeKey
        [self addNotificationAttachmentContent:content attachmentName:movieName options:@{@"UNNotificationAttachmentOptionsThumbnailTimeKey":@10} withCompletion:^(NSError *error, UNNotificationAttachment *notificationAtt) {
            
            movieAtt = [notificationAtt copy];
            
        }];
        
    }
    
    NSMutableArray * array = [NSMutableArray array];
    //    [array addObject:soundAtt];
    //    [array addObject:imageAtt];
    [array addObject:movieAtt];
    
    content.attachments = array;
    
    //添加通知下拉动作按钮
    NSMutableArray * actionMutableArray = [NSMutableArray array];
    UNNotificationAction * actionA = [UNNotificationAction actionWithIdentifier:@"identifierNeedUnlock" title:@"进入应用" options:UNNotificationActionOptionAuthenticationRequired];
    UNNotificationAction * actionB = [UNNotificationAction actionWithIdentifier:@"identifierRed" title:@"忽略" options:UNNotificationActionOptionDestructive];
    [actionMutableArray addObjectsFromArray:@[actionA,actionB]];
    
    if (actionMutableArray.count > 1) {
        
        UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:@"categoryNoOperationAction" actions:actionMutableArray intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        [center setNotificationCategories:[NSSet setWithObjects:category, nil]];
        content.categoryIdentifier = @"categoryNoOperationAction";
    }
    
    //UNTimeIntervalNotificationTrigger   延时推送
    //UNCalendarNotificationTrigger       定时推送
    //UNLocationNotificationTrigger       位置变化推送
    
    UNTimeIntervalNotificationTrigger * tirgger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    
    //建立通知请求
    UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:tirgger];
    
    //将建立的通知请求添加到通知中心
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        NSLog(@"%@本地推送 :( 报错 %@",identifier,error);
        
    }];
}



/**
 增加通知附件
 @param content 通知内容
 @param attachmentName 附件名称
 @param options 相关选项
 @param completion 结果回调
 */
-(void)addNotificationAttachmentContent:(UNMutableNotificationContent *)content attachmentName:(NSString *)attachmentName  options:(NSDictionary *)options withCompletion:(void(^)(NSError * error , UNNotificationAttachment * notificationAtt))completion{
    
    
    NSArray * arr = [attachmentName componentsSeparatedByString:@"."];
    
    NSError * error;
    
    NSString * path = [[NSBundle mainBundle]pathForResource:arr[0] ofType:arr[1]];
    
    UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:[NSString stringWithFormat:@"notificationAtt_%@",arr[1]] URL:[NSURL fileURLWithPath:path] options:options error:&error];
    
    if (error) {
        
        NSLog(@"attachment error %@", error);
        
    }
    
    completion(error,attachment);
    //获取通知下拉放大图片
    content.launchImageName = attachmentName;
    
}






- (void)masonryLayout {
    // 远程推送
    [self.remoteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(0.8f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.4f);
        make.height.equalTo(self.remoteButton.mas_width).multipliedBy(0.4f);
    }];
    // 本地推送
    [self.localButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.2f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.4f);
        make.height.equalTo(self.localButton.mas_width).multipliedBy(0.4f);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
