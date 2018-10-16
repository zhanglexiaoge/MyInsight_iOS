
//
//  ScrollViewVC.m
//  MyInsight
//
//  Created by SongMengLong on 2018/7/24.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "ScrollViewVC.h"

@interface ScrollViewVC ()<UIScrollViewDelegate>

// 记录当前翻到了第几页
@property (nonatomic, assign)int flag;

@property (nonatomic, retain)UIScrollView *scroll;

@property (nonatomic, retain)UIPageControl *pageControl;

@property (nonatomic, retain)NSMutableArray *images;

@property(nonatomic,retain)NSTimer *myTimer;

@property(nonatomic,assign)NSInteger index;

@end

@implementation ScrollViewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.images = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"scrollimage%d.jpg", i+1]];
            [self.images addObject:image];
        }
        
        id imageFirst = [self.images firstObject];
        id imageLast = [self.images lastObject];
        
        [self.images insertObject:imageLast atIndex:0];
        [self.images addObject:imageFirst];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"滚动循环";
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.scroll = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.scroll.backgroundColor = [UIColor lightGrayColor];
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width * [self.images count], self.view.frame.size.height);
    self.scroll.contentOffset = CGPointMake(self.scroll.frame.size.width, 0);
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.pagingEnabled = YES;
    self.scroll.delegate = self;
    [self.view addSubview:self.scroll];
    
    // 可以根据数组里元素的数量来 循环
    for (int index = 0; index < self.images.count; index++)
    {
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + self.view.frame.size.width * index, 0, self.view.frame.size.width, self.view.frame.size.height)];
        scrollView.minimumZoomScale = 0.1;
        scrollView.maximumZoomScale = 2.0;
        scrollView.delegate = self;
        [self.scroll addSubview:scrollView];
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[self.images objectAtIndex:index]];
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height - 40, 260, 30)];
    self.pageControl.numberOfPages = [self.images count] - 2;
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:self.pageControl];
    
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    //记录当前页码,默认为0
    self.index = 0;
}

- (void)timerAction:(NSTimer *)timer {
    
    //使用scrollview自带的滚动动画,实现起来效果不好,有bug.所以需要自己写动画效果
    [UIView animateWithDuration:0.5 animations:^{
        [self.scroll setContentOffset:CGPointMake((self.index + 1) * self.scroll.frame.size.width, 0)];
        
    }];
    
    //如果滑动到最后一页
    if (self.scroll.contentOffset.x == (self.images.count-1)*self.scroll.frame.size.width) {
        //快速移动到第一页
        [self.scroll setContentOffset:CGPointMake(self.scroll.frame.size.width, 0)];
        
        self.index = 0;
        
    }
    self.index++;
}


// UIPageControl类型对象中调用的方法
- (void)changePage:(UIPageControl *)page {
    [self.scroll setContentOffset:CGPointMake((page.currentPage + 1) * self.scroll.frame.size.width, 0) animated:YES];
}

// 使页面上点的变化与视图的变化一致
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = (scrollView.contentOffset.x - self.scroll.frame.size.width) / scrollView.frame.size.width;
    
}

// 当手指接触的时候让定时器停止
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.myTimer invalidate];
    self.myTimer = nil;
}

// 当手指离开的时候开始滑动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}

//定时器在不断循环滚动,就不会减速停止,此方法就不会走
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scroll == scrollView) {
        //每次减速结束都让scollView所有的scrollView子视图缩放变为1
        for (UIScrollView * scrollv in scrollView.subviews) {
            if ([scrollv isKindOfClass:[UIScrollView class]]) {
                scrollv.zoomScale = 1.0;
            }
        }
        
        if (self.scroll.contentOffset.x >= self.scroll.frame.size.width * (self.images.count - 1)) {
            NSLog(@"最后一页");//循环滚动
            [self.scroll setContentOffset:CGPointMake(self.scroll.frame.size.width, 0) animated:NO];
        }
        
        if (self.scroll.contentOffset.x <= 0) {
            [self.scroll setContentOffset:CGPointMake(self.scroll.frame.size.width * (self.images.count - 2), 0) animated:NO];
        }
        
    }
    //不管怎么移动,保证self.index存的是当前的页码
    self.index = self.scroll.contentOffset.x / self.scroll.frame.size.width -1;
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
