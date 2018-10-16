//
//  CoreDataVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/21.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CoreDataVC.h"
#import <Masonry.h>
#import "UIColor+Category.h"

@interface CoreDataVC ()
// 创建
@property (nonatomic, strong) UIButton *creatButton;
// 更新
@property (nonatomic, strong) UIButton *updateButton;
// 读取
@property (nonatomic, strong) UIButton *retrieveButton;
// 删除
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation CoreDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CoreData";
    
    [self creatContentView];
    
    [self masonryLayout];
    
}

- (void)creatContentView {
    self.creatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.creatButton];
    self.creatButton.backgroundColor = [UIColor RandomColor];
    [self.creatButton setTitle:@"创建" forState:UIControlStateNormal];
    [self.creatButton addTarget:self action:@selector(creatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.updateButton];
    self.updateButton.backgroundColor = [UIColor RandomColor];
    [self.updateButton setTitle:@"更新" forState:UIControlStateNormal];
    [self.updateButton addTarget:self action:@selector(updateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.retrieveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.retrieveButton];
    self.retrieveButton.backgroundColor = [UIColor RandomColor];
    [self.retrieveButton setTitle:@"读取" forState:UIControlStateNormal];
    [self.retrieveButton addTarget:self action:@selector(retrieveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.deleteButton];
    self.deleteButton.backgroundColor = [UIColor RandomColor];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)creatButtonAction:(UIButton *)button {
    NSLog(@"创建数据库表");
}

- (void)updateButtonAction:(UIButton *)button {
    NSLog(@"更新数据库");
}

- (void)retrieveButtonAction:(UIButton *)button {
    NSLog(@"读取数据库");
}

- (void)deleteButtonAction:(UIButton *)button {
    NSLog(@"删除数据库");
}

- (void)masonryLayout {
    [self.creatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(0.5f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.4f);
        make.height.equalTo(self.creatButton.mas_width).multipliedBy(0.4f);
    }];
    
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(0.8f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.4f);
        make.height.equalTo(self.updateButton.mas_width).multipliedBy(0.4f);
    }];
    
    [self.retrieveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.2f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.4f);
        make.height.equalTo(self.retrieveButton.mas_width).multipliedBy(0.4f);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.6f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.4f);
        make.height.equalTo(self.deleteButton.mas_width).multipliedBy(0.4f);
    }];
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
