//
//  SocketVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/3/21.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "SocketVC.h"

@interface SocketVC ()

@end

@implementation SocketVC

/*
 [<iOS开发>之CocoaAsyncSocket使用](https://www.jianshu.com/p/321bc95d077f)
 
 原生，不使用第三方类库
 [iOS 开发 网络编程详解之Socket详解](https://blog.csdn.net/kuangdacaikuang/article/details/53386782)
 [iOS socket通信（不使用框架的简单实例）](https://www.jianshu.com/p/e86a4b6568fa)
 
 c语言：
 [linux下socket通信，server和client简单例子](https://www.oschina.net/code/snippet_97047_675)
 [Linux下C语言实现的一个多线程Socket服务器端](http://starlight36.com/post/linux_c_language_muti_thread_socket)
 [Linux下C编写基本的多线程socket服务器](https://www.cnblogs.com/nerohwang/p/3602233.html)
 
 [苹果官方文档视频](https://developer.apple.com/videos/play/wwdc2016/719/)
 
 [IM 即时通讯技术在多应用场景下的技术实现，以及性能调优（ iOS 视角）（附 PPT 与 2 个半小时视频）](https://www.jianshu.com/p/8cd908148f9e)
 
 [浅析心跳](https://blog.csdn.net/hbjixieyuan/article/details/55048916)
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Socket通讯";
    
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
