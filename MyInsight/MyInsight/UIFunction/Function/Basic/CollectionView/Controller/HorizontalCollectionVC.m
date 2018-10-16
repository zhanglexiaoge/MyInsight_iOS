//
//  HorizontalCollectionVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/20.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "HorizontalCollectionVC.h"
#import "UIColor+Category.h"
#import "MIHorizontalLayout.h"
#import <Masonry.h>

@interface HorizontalCollectionVC ()<UICollectionViewDelegate, UICollectionViewDataSource, MIHorizontalLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HorizontalCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"水平流布局";
    
    [self creatCollectionView];
}

- (void)creatCollectionView {
    // 页面布局
    MIHorizontalLayout *flowLayout = [[MIHorizontalLayout alloc] initWithDelegate:self];
   
    // 集合Views
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(0.0f);
    }];
    self.collectionView.backgroundColor = [UIColor RandomColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // 注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}

#pragma mark - 实现代理协议
- (CGFloat)waterflowLayout:(MIHorizontalLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight {
    return (arc4random() % 4 + 1) * itemHeight;
}

- (NSInteger)waterflowLayout:(MIHorizontalLayout *)waterflowLayout linesInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor RandomColor];
    
    cell.contentView.clipsToBounds = YES;
    if (![cell.contentView viewWithTag:100]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        label.tag = 100;
        label.textColor = [UIColor redColor];
        label.font = [UIFont boldSystemFontOfSize:17];
        [cell.contentView addSubview:label];
    }
    
    UILabel *label = [cell.contentView viewWithTag:100];
    
    label.text = [NSString stringWithFormat:@"%zd", indexPath.item];
    
    return cell;
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
