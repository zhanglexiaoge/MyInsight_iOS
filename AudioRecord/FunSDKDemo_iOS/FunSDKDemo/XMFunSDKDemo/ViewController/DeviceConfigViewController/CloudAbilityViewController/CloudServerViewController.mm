//
//  CloudServerViewController.m
//  FunSDKDemo
//
//  Created by XM on 2019/1/3.
//  Copyright © 2019年 XM. All rights reserved.
//

#import "CloudServerViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "DeviceManager.h"
#import "SystemInfoConfig.h"

@protocol OCAndJSInteractionProtocol <JSExport>

-(void)openCloudStorageList:(NSString *)param;

@end

@interface OCAndJSInteraction : NSObject <OCAndJSInteractionProtocol>

@property (nonatomic,weak) id <OCAndJSInteractionProtocol>delegate;

@end

@implementation OCAndJSInteraction

-(void)openCloudStorageList:(NSString *)param
{
    if (self.delegate) {
        [self.delegate openCloudStorageList:param];
    }
}

@end

@interface CloudServerViewController () <UIWebViewDelegate,OCAndJSInteractionProtocol,SystemInfoConfigDelegate>


@property (nonatomic, strong) NSString *hardWare;       //硬件版本

@property (nonatomic, strong) NSString *softWare;       //软件版本

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSURLRequest *webURLRequest;

@property (nonatomic,strong) JSContext *context;

@property (nonatomic,strong) UIWebView *wakeUpWeb;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic,strong) NSTimer *countTimer;
@property (nonatomic,assign) int curLoadNum; // 范围 1-10
@property (nonatomic,assign) BOOL ifFinished;   // 是否加载完毕

@property (nonatomic,strong) SystemInfoConfig *config;
@end

@implementation CloudServerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = TS("Cloud_storage");
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,NavHeight, ScreenWidth, ScreenHeight-NavHeight)];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 0, ScreenWidth, 10);
    self.progressView.progress = 0;
    self.progressView.progressTintColor = [UIColor blueColor];
    self.progressView.trackTintColor = [UIColor lightGrayColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.webView addSubview:self.progressView];
    
    // 先判断是否是主账号，然后根据结果继续操作 （这里回调后没有判断，没有联系人系统的话，这个也不用判断）
    [[DeviceManager getInstance] checkMasterAccount:nil];
    //判断当前硬件和软件信息，云服务需要用到这两个信息
    [self checkDeviceAbility];
}
#pragma mark 检查设备硬件软件信息
- (void)checkDeviceAbility {
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    DeviceObject *device = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
    if (device.info.hardWare && device.info.hardWare.length >0 && device.info.softWareVersion && device.info.softWareVersion.length >0) {
        [self requestURL];
        //刷新加载进度
        self.countTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(countTimerAction) userInfo:nil repeats:YES];
        self.curLoadNum = 0;
        self.ifFinished = NO;
    }else{
        _config = [[SystemInfoConfig alloc] init];
        _config.delegate = self;
        [_config getSystemInfo];
    }
}
#pragma mark  webView请求
-(void)requestURL {
    char szUserID[128] = {0};
    FUN_GetFunStrAttr(EFUN_ATTR_LOGIN_USER_ID, szUserID, 128);
    NSString *URLString;
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    DeviceObject *device = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
    //支付云存储功能网页支持中英文两种语言
    if ([currentLanguage containsString:@"zh-Hans"] || [currentLanguage containsString:@"zh-Hant"]) {
        URLString = [NSString stringWithFormat:@"https://boss.xmcsrv.net/index.do?user_id=%s&uuid=%@&hardware=%@&software=%@&lan=zh-CN&appKey=%s",szUserID,device.deviceMac,device.info.hardWare,device.info.softWareVersion,APPKEY];
    }else{
        URLString = [NSString stringWithFormat:@"https://boss.xmcsrv.net/index.do?user_id=%s&uuid=%@&hardware=%@&software=%@&lan=en&appKey=%s",szUserID,device.deviceMac,device.info.hardWare,device.info.softWareVersion,APPKEY];
    }
    
    self.webURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [self.webView loadRequest:self.webURLRequest];
}

#pragma mark UIWebDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    if ([url hasPrefix:@"alipays://"] || [url hasPrefix:@"alipay://"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        
        [self requestURL];
        return NO;
    }
    else if ([url hasPrefix:@"weixin://wap/pay"]){
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    NSDictionary *header = [request allHTTPHeaderFields];
    BOOL hasReferer = [header objectForKey:@"Referer"] != nil;
    
    if (hasReferer && [url hasPrefix:@"https://wx.tenpay.com"] && ![[header objectForKey:@"Referer"] isEqualToString:@"boss.xmcsrv.net://"]) {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *urls = [request URL];
                NSString *originUrlStr = urls.absoluteString;
                
                NSArray *array = [originUrlStr componentsSeparatedByString:@"redirect_url"];
                NSString *nowUrlStr = [NSString stringWithFormat:@"%@redirect_url%@",[array objectAtIndex:0],@"boss.xmcsrv.net://"];
                NSURL *newUrl = [NSURL URLWithString:nowUrlStr];
                
                NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:newUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
                [req setHTTPMethod:@"GET"];
                [req setValue:@"boss.xmcsrv.net://" forHTTPHeaderField:@"Referer"];
                [self.wakeUpWeb loadRequest:req];
            });
        });
        [self requestURL];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.ifFinished = YES;
    // 还可以为js端提供完整的原生方法供其调用（记得导入#import <JavaScriptCore/JavaScriptCore.h>）
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    OCAndJSInteraction *ocjsObj = [[OCAndJSInteraction alloc] init];
    ocjsObj.delegate = self;
    self.context[@"XmAppJsSDK"] = ocjsObj;
}

#pragma mark webView点击回调
-(void)openCloudStorageList:(NSString *)param {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([param isEqualToString:@"0"]) {
            [self gotoCloudPhotoVC];
        }
        else if ([param isEqualToString:@"1"]) {
            [self gotoCloudVideoPlaybackVC];
        }
    });
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

#pragma mark - 模拟加载动画
-(void)countTimerAction{
    if (self.curLoadNum < 24 && self.ifFinished == NO) {
        self.curLoadNum++;
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
            self.progressView.progress = self.curLoadNum / 30.0;
        } completion:nil];
    }
    else{
        if (self.ifFinished) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
                self.progressView.progress = 1;
            } completion:^(BOOL complete){
                self.progressView.hidden = YES;
                
                [self.countTimer invalidate];
                self.countTimer = nil;
            }];
        }
    }
}

#pragma mark 判断主账号信息结果回调
- (void)checkMaster:(NSString *)sId Result:(int)result {
    if (result >=1) { //主账号
        
    }else if (result == 0) { //不是主账号
        
    }else{//获取失败
        [MessageUI ShowErrorInt:result];
    }
}
#pragma mark 获取能力级回调信息
- (void)SystemInfoConfigGetResult:(NSInteger)result {
    if (result <=0) {
        [MessageUI ShowErrorInt:(int)result];
    }else{
        [self checkDeviceAbility];
    }
}
#pragma mark 界面跳转
- (void)gotoCloudPhotoVC {
    CloudPhotoViewController *cloudPhotoVC = [[CloudPhotoViewController alloc] init];
    [self.navigationController pushViewController:cloudPhotoVC animated:YES];
}
- (void)gotoCloudVideoPlaybackVC {
    CloudVideoViewController *cloudVideoVC = [[CloudVideoViewController alloc] init];
    [self.navigationController pushViewController:cloudVideoVC animated:YES];
}
@end
