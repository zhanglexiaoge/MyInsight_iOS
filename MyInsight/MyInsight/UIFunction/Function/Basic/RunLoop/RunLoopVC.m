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
    
    [self aaaa];
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
