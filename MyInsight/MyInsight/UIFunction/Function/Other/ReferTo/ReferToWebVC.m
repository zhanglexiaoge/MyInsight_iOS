//
//  ReferToWebVC.m
//  MyInsight
//
//  Created by SongMengLong on 2018/9/25.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "ReferToWebVC.h"
#import <WebKit/WebKit.h>

@interface ReferToWebVC ()<UIWebViewDelegate>

@end

@implementation ReferToWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self useWKWebView];
}

#pragma mark - 使用UIWebView
- (void)useUIWebView {
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    //webView.delegate = self;
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlString]];
    [webView loadRequest:request];
    // 添加view
    [self.view addSubview:webView];
}

#pragma mark - 使用WKWebView
- (void)useWKWebView {
    /*
     iOS WKWebView使用总结
     https://www.jianshu.com/p/20cfd4f8c4ff
     iOS WKWebView使用总结
     https://www.jianshu.com/p/20cfd4f8c4ff
     */
    
    
    // 1.创建webview
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    // 2.创建请求
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.htmlString]];
    // 3.加载网页
    [webView loadRequest:request];
    // 最后将webView添加到界面
    [self.view addSubview:webView];
    
    NSSet  *websiteDataTypes = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache]];
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
