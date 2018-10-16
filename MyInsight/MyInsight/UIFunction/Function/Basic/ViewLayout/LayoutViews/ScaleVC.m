//
//  ScaleVC.m
//  MyInsight
//
//  Created by SongMengLong on 2017/12/24.
//  Copyright © 2017年 SongMenglong. All rights reserved.
//

#import "ScaleVC.h"
#import <Masonry.h>

@interface ScaleVC ()

// 功能view
@property (nonatomic, strong) UIView *functionView;

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation ScaleVC

/*
 代码约束等分布局
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"等分布局";
    
    [self creatFunctionViewView];
}

// 创建buttons的view
- (void)creatFunctionViewView {
    self.functionView = [[UIView alloc] init];
    [self.view addSubview:self.functionView];
    self.functionView.backgroundColor = [UIColor redColor];
    
    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64.0f);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.offset(40.0f);
    }];
}

- (void)viewLayoutMarginsDidChange {
    [super viewLayoutMarginsDidChange];
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
