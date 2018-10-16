
//
//  LockVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/3/19.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "LockVC.h"
#import "UIColor+Category.h"

@interface LockVC ()

@property (nonatomic, strong) NSMutableArray *myMutableList;
//要运用atomic 线程安全 只能是相对安全 只有这个属性也会出现线程问题
@property (strong, nonatomic) NSMutableArray *myThreadList;
// 安全
@property (strong, atomic) NSLock *mylock;

@end

@implementation LockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"同步锁";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化
    if (!self.myMutableList) {
        self.myMutableList = [@[@"图片1",@"图片2",@"图片3",@"图片4",@"图片5",@"图片6",@"图片7",@"图片8",@"图片9"] mutableCopy];
    }
    //初始化锁对象
    self.mylock = [[NSLock alloc]init];
    
    [self addArrayThtead];
}

- (void)addArrayThtead {
    if (!self.myThreadList) {
        self.myThreadList=[[NSMutableArray alloc]init];
    }
    
    [self.myThreadList removeAllObjects];
    
    for(int i=0; i<10;i++)
    {
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadAction:) object:[NSNumber numberWithInt:i]];
        thread.name=[NSString stringWithFormat:@"myThread%i",i];
        
        [self.myThreadList addObject:thread];
    }
    
    
    for (int i=0; i<self.myThreadList.count; i++) {
        NSThread *thread=self.myThreadList[i];
        [thread start];
    }
}

- (void)loadAction:(NSNumber *)index {
    
    NSThread *thread = [NSThread currentThread];
    NSLog(@"loadAction是在线程%@中执行",thread.name);
    
    //结合下面的cancel运用 进行强制退出线程的操作
    if ([[NSThread currentThread] isCancelled]) {
        NSLog(@"当前thread-exit被exit动作了");
        [NSThread exit];
    }
    
    //第一种情况，第二种情况：
    //        NSString *name;
    //        if (self.myMutableList.count>0) {
    //            name=[self.myMutableList lastObject];
    //            [self.myMutableList removeObject:name];
    //        }
    
    //第三种情况
    //        NSString *name;
    //
    //        //加锁
    //        [_mylock lock];
    //        if (self.myMutableList.count>0) {
    //            name=[self.myMutableList lastObject];
    //            [self.myMutableList removeObject:name];
    //        }
    //        [_mylock unlock];
    
    //    第四种情况
    //线程同步
    NSString *name;
    @synchronized(self){
        if (self.myMutableList.count>0) {
            name=[self.myMutableList lastObject];
            [self.myMutableList removeObject:name];
        }
    }
    
    NSLog(@"当前要加载的图片名称%@",name);
    
    //回主线程去执行  有些UI相应 必须在主线程中更新
    [self performSelectorOnMainThread:@selector(updateImage) withObject:nil waitUntilDone:YES];
}

- (void)updateImage {
    @autoreleasepool {
        NSLog(@"执行完成了");
    }
    
    //输出：执行方法updateImage是在主线程中
}

//******解决Thread中的内存问题
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //结合VC生命周期 viewWillDisappear退出页面时就把线程标识为cancel 使用Thread一定要在退出前进行退出，否则会有闪存泄露的问题
    for (int i=0; i<self.myThreadList.count; i++){
        NSThread *thread=self.myThreadList[i];
        if (![thread isCancelled]) {
            NSLog(@"当前thread-exit线程被cancel");
            [thread cancel];
            //cancel 只是一个标识 最下退出强制终止线程的操作是exit 如果单写cancel 线程还是会继续执行
        }}
}

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor RandomColor] range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
    
    return title;
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
