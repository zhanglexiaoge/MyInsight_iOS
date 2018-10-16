//
//  WelcomeVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/2/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "WelcomeVC.h"
#import <Masonry.h>
#import "MainRevealVC.h"

@interface WelcomeVC ()<UIScrollViewDelegate>
// 滑动View
@property (nonatomic, strong) UIScrollView *scrollView;
// 页面控制
@property (nonatomic, strong) UIPageControl *pageControl;
// 图片数组
@property (nonatomic, strong) NSArray *pageArray;

@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pageArray = @[@"launch_0", @"launch_1", @"launch_2", @"launch_3"];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
    self.scrollView.backgroundColor = [UIColor magentaColor];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*self.pageArray.count, [UIScreen mainScreen].bounds.size.height);
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    
    for (int i = 0; i < self.pageArray.count; i++) {
        UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*i, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.scrollView addSubview:pageView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [pageView addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:[self.pageArray objectAtIndex:i]];
        
        if (i == self.pageArray.count-1) {
            NSLog(@"最后一个页面");
            UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [pageView addSubview:startButton];
            [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imageView.mas_centerX).multipliedBy(1.0f);
                make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.7f);
                make.width.offset(150.0f);
                make.height.offset(50.0f);
            }];
            startButton.backgroundColor = [UIColor magentaColor];
            [startButton setTitle:@"开始" forState:UIControlStateNormal];
            startButton.layer.masksToBounds = YES;
            startButton.layer.cornerRadius = 10.0f;
            startButton.titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
            // 添加事件
            [startButton addTarget:self action:@selector(startButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    // page
    self.pageControl = [[UIPageControl alloc] init];
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.9f);
        make.width.offset(100.0f);
        make.height.offset(20.0f);
    }];
    self.pageControl.numberOfPages = 4;
}

#pragma mark - 开始button事件
- (void)startButtonAction:(UIButton *)button {
    MainRevealVC *mainRevealVC = [[MainRevealVC alloc] init];
    // 模态推出
    [self presentViewController:mainRevealVC animated:NO completion:NULL];
}

#pragma mark - 实现ScrollView代理协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetWidth = self.scrollView.contentOffset.x;
    int pageNum = offsetWidth / [[UIScreen mainScreen] bounds].size.width;
    self.pageControl.currentPage = pageNum;
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
