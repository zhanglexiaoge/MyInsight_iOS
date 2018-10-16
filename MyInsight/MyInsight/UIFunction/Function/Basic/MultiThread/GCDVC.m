//
//  GCDVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/3/19.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "GCDVC.h"
#import <Masonry.h>
#import "UIColor+Category.h"
#import "Header.h"

@interface GCDVC ()
// 输入
@property (nonatomic, strong) UITextView *inputTextView;
// 定时器Label
@property (nonatomic, strong) UILabel *timerLabel;

@end

@implementation GCDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"GCD多线程";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}


- (void)demoAAA {
    // 展示
    //[self display];
    [self timerLabelUI];
    
    // 并发队列 + 同步执行
    [self syncConCurrent];
    //并发队列 + 异步执行
    [self asyncConcurrent];
    // 串行队列 + 同步执行
    [self syncSerial];
    // 串行队列 + 异步执行
    [self asyncSerial];
    // 主队列 + 同步执行 直接闪退
    //[self syncMain];
    // 主队列 + 异步执行
    [self asyncMain];
    // 全局队列+ 异步执行
    [self asyncGloba];
}


#pragma mark - 多线程设计定时器
- (void)timerLabelUI {
    self.timerLabel = [[UILabel alloc] init];
    [self.view addSubview:self.timerLabel];
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.0f);
    }];
    // 多线程倒计时
    __block int timeout = 5; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.timerLabel.text = @"长生不老";
                self.timerLabel.userInteractionEnabled = YES;
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                self.timerLabel.text = [NSString stringWithFormat:@"%@",strTime];
                [UIView commitAnimations];
                self.timerLabel.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}



#pragma mark - 并发队列 + 同步执行
- (void)syncConCurrent {
    NSLog(@"并发队列 + 同步执行：syncConcurrent---begin");
    
    dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"并发队列 + 同步执行：1：%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"并发队列 + 同步执行：2：%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"并发队列 + 同步执行：3：%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"并发队列 + 同步执行：syncConcurrent---end");
    
    //输出内容：
    //    syncConcurrent---begin
    //    1------<NSThread: 0x60000007a080>{number = 1, name = main}
    //    1------<NSThread: 0x60000007a080>{number = 1, name = main}
    //    2------<NSThread: 0x60000007a080>{number = 1, name = main}
    //    2------<NSThread: 0x60000007a080>{number = 1, name = main}
    //    3------<NSThread: 0x60000007a080>{number = 1, name = main}
    //    3------<NSThread: 0x60000007a080>{number = 1, name = main}
    //    syncConcurrent---end
    
    //    说明
    //    从并发队列 + 同步执行中可以看到，所有任务都是在主线程中执行的。由于只有一个线程，所以任务只能一个一个执行
    //    所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间，这说明任务是添加到队列中马上执行的
}

#pragma mark - 并发队列 + 异步执行
- (void)asyncConcurrent {
    NSLog(@"并发队列 + 异步执行：asyncConcurrent---begin");
    
    dispatch_queue_t queue= dispatch_queue_create("test.asyncqueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"并发队列 + 异步执行：1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"并发队列 + 异步执行：2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"并发队列 + 异步执行：3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"并发队列 + 异步执行：asyncConcurrent---end");
    
    
    //输出内容：
    //    asyncConcurrent---begin
    //    asyncConcurrent---end
    //    3------<NSThread: 0x608000474fc0>{number = 9, name = (null)}
    //    3------<NSThread: 0x608000474fc0>{number = 9, name = (null)}
    //    1------<NSThread: 0x60000007f780>{number = 10, name = (null)}
    //    1------<NSThread: 0x60000007f780>{number = 10, name = (null)}
    //    2------<NSThread: 0x600000460000>{number = 5, name = (null)}
    //    2------<NSThread: 0x600000460000>{number = 5, name = (null)}
    
    //    说明
    //    在并发队列 + 异步执行中可以看出，除了主线程，又开启了3个线程，并且任务是交替着同时执行的。
    //    所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始异步执行
}

#pragma mark - 串行队列 + 同步执行
- (void)syncSerial {
    NSLog(@"串行队列 + 同步执行：syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("test.syncSerial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"串行队列 + 同步执行：1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"串行队列 + 同步执行：2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"串行队列 + 同步执行：3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"串行队列 + 同步执行：syncSerial---end");
    
    //输出内容
    //    syncSerial---begin
    //    1------<NSThread: 0x608000260580>{number = 1, name = main}
    //    1------<NSThread: 0x608000260580>{number = 1, name = main}
    //    2------<NSThread: 0x608000260580>{number = 1, name = main}
    //    2------<NSThread: 0x608000260580>{number = 1, name = main}
    //    3------<NSThread: 0x608000260580>{number = 1, name = main}
    //    3------<NSThread: 0x608000260580>{number = 1, name = main}
    //    syncSerial---end
    
    //    说明
    //    所有任务都是在主线程中执行的，并没有开启新的线程。而且由于串行队列，所以按顺序一个一个执行
    //    所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间，这说明任务是添加到队列中马上执行的
    
}

#pragma mark - 串行队列 + 异步执行
- (void)asyncSerial {
    NSLog(@"串行队列 + 异步执行:asyncSerial--begin");
    
    dispatch_queue_t queue = dispatch_queue_create("test.asyncSerial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"串行队列 + 异步执行:1--%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"串行队列 + 异步执行:2--%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"串行队列 + 异步执行:3--%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"串行队列 + 异步执行:asyncSerial--end");
    
    //输出的内容
    //    asyncSerial---begin
    //    asyncSerial---end
    //    1------<NSThread: 0x608000663900>{number = 4, name = (null)}
    //    1------<NSThread: 0x608000663900>{number = 4, name = (null)}
    //    2------<NSThread: 0x608000663900>{number = 4, name = (null)}
    //    2------<NSThread: 0x608000663900>{number = 4, name = (null)}
    //    3------<NSThread: 0x608000663900>{number = 4, name = (null)}
    //    3------<NSThread: 0x608000663900>{number = 4, name = (null)}
    
    //    说明
    //    开启了一条新线程，但是任务还是串行，所以任务是一个一个执行
    //    所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始同步执行
}

#pragma mark - 主队列 + 同步执行 直接闪退
- (void)syncMain {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    
    dispatch_sync(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"主队列 + 同步执行:1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"主队列 + 同步执行:2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"主队列 + 同步执行:3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"主队列 + 同步执行:asyncSerial---end");
}

- (void)asyncMain {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    
    dispatch_async(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"主队列 + 异步执行:1-%@",[NSThread currentThread]);
        }
    });
    dispatch_async(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"主队列 + 异步执行:2-%@",[NSThread currentThread]);
        }
    });
    dispatch_async(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"主队列 + 异步执行:3-%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"主队列 + 异步执行:asyncSerial---end");
}

#pragma mark - 全局队列+ 异步执行
- (void)asyncGloba {
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2. 异步执行
    for (int i = 0; i < 10; ++i) {
        dispatch_async(q, ^{
            NSLog(@"全局队列+ 异步执行：asyncGloba：%@ %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"全局队列+ 异步执行 come here");
    
    //输出内容：
    //    come here
    //    asyncGloba：<NSThread: 0x608000464600>{number = 5, name = (null)} 0
    //    asyncGloba：<NSThread: 0x608000464600>{number = 5, name = (null)} 3
    //    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 1
    //    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 5
    //    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 6
    //    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 7
    //    asyncGloba：<NSThread: 0x60800047e100>{number = 19, name = (null)} 2
    //    asyncGloba：<NSThread: 0x608000464600>{number = 5, name = (null)} 4
    //    asyncGloba：<NSThread: 0x60800047e100>{number = 19, name = (null)} 9
    //    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 8
    //    说明：come here 说明是异步执行，没有马上执行，并且有开子线程执行
}

- (void)display {
    
    self.inputTextView = [[UITextView alloc] init];
    [self.view addSubview:self.inputTextView];
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(60, 0, 0, 0));
    }];
    self.inputTextView.userInteractionEnabled = YES;
    self.inputTextView.editable = NO;
    self.inputTextView.selectable = NO;
    self.inputTextView.scrollEnabled = YES;
    self.inputTextView.textColor = [UIColor RandomColor];
    self.inputTextView.font = AdaptedFontSize(16);
    
    self.inputTextView.text = @"------------------------------------------------------------------------------------------\n\
    理论知识\n\
    同步执行（sync）：只能在当前线程中执行任务，不具备开启新线程的能力\n\
    异步执行（async）：可以在新的线程中执行任务，具备开启新线程的能力\n\
    ------------------------------------------------------------------------------------------\n\
    \n\
    ------------------------------------------------------------------------------------------\n\
    并发队列（Concurrent Dispatch Queue）：可以让多个任务并发（同时）执行（自动开启多个线程同时执行任务）,并发功能只有在异步（dispatch_async）函数下才有效\n\
    串行队列（Serial Dispatch Queue）：让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务）\n\
    ------------------------------------------------------------------------------------------\n\
    \n\
    ------------------------------------------------------------------------------------------\n\
    串行队列的创建方法\n\
    dispatch_queue_t queue= dispatch_queue_create(\"test.queue\", DISPATCH_QUEUE_SERIAL);\n\
    并发队列的创建方法\n\
    dispatch_queue_t queue= dispatch_queue_create(\"test.queue\", DISPATCH_QUEUE_CONCURRENT);\n\
    创建全局并发队列\n\\n\
    dispatch_get_global_queue来创建全局并发队列\n\
    \n\
    \n\
    dispatch_queue_t queue = dispatch_get_main_queue() 程序一启动，主线程就已经存在，主队列也同时就存在了，所以主队列不需要创建，只需要获取\n\
    \n\
    ------------------------------------------------------------------------------------------\n\
    六种类型：\n\
    并发队列 + 同步执行\n\
    并发队列 + 异步执行\n\
    串行队列 + 同步执行\n\
    串行队列 + 异步执行\n\
    主队列 + 同步执行\n\
    主队列 + 异步执行\n\
    ------------------------------------------------------------------------------------------\n\
    ";
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
