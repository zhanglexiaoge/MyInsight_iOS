//
//  RunLoopVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/20.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "RunLoopVC.h"
#import "MyThread.h"

@interface RunLoopVC ()
// 定时器
@property (nonatomic, strong) NSMutableDictionary<id, NSTimer *> *timers;
// 线程
@property (nonatomic, strong) NSMutableDictionary<id, NSThread *> *threads;
// 观察者
@property (nonatomic, assign) CFRunLoopObserverRef observer;

@end

@implementation RunLoopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"RunLoop";
    
    // 初始化
    self.timers = [NSMutableDictionary dictionary];
    self.threads = [NSMutableDictionary dictionary];
    
    //[self aaaa];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //同时苹果还提供了一个操作 Common 标记的字符串：kCFRunLoopCommonModes (NSRunLoopCommonModes)，你可以用这个字符串来操作 Common Items，或标记一个 Mode 为 "Common"。使用时注意区分这个字符串和其他 mode name。
        //commonModeItems
        //这里使用的模式是：NSRunLoopCommonModes，这个模式等效于NSDefaultRunLoopMode和NSEventTrackingRunLoopMode的结合。
        //运行在此模式下 commonModeItems 内 每当 RunLoop 的内容发生变化时，RunLoop 都会自动将 commonModeItems 里的 Source/Observer/Timer 同步到具有 "Common" 标记的所有Mode里。由于主线程的 RunLoop 里有两个预置的 Mode：kCFRunLoopDefaultMode 和 UITrackingRunLoopMode。这两个 Mode 都已经被标记为"Common"属性。
        //所以NSRunLoopCommonModes此模式会处理 来自UITrackingRunLoopMode和NSDefaultRunLoopMode内的时间
        
        //设置主线程的运行模式为NSRunLoopCommonModes 主线程可以接受来自NSDefaultRunLoopMode和UITrackingRunLoopMode模式下的事件
        //[[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    });
    
}

- (void)aaaa {
    MyThread * thread = [[MyThread alloc]initWithTarget:self
                                               selector:@selector(startNewThread) object:nil];
    [thread start];
    
}

-(void)startNewThread{
    NSLog(@"辅助线程执行的代码");
    
}


- (void)bbbb {
    
}

- (void)cccc {
    
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
