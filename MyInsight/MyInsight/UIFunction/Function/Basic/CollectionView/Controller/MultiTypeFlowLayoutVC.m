//
//  MultiTypeFlowLayoutVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/17.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "MultiTypeFlowLayoutVC.h"
#import <Masonry.h> // 代码约束布局
// 三种布局方式
#import "MIGirdLayout.h"
#import "MILineLayout.h"
#import "MICircleLayout.h"

@interface MultiTypeFlowLayoutVC ()<UICollectionViewDelegate, UICollectionViewDataSource, MICircleLayoutDelegate>
// 集合view
@property (nonatomic, strong) UICollectionView *collectionView;
// 改变button
@property (nonatomic, strong) UIButton *changeButton;
// 图片数组
@property (nonatomic, strong) NSMutableArray<UIImage *> *imagesArray;

@end

@implementation MultiTypeFlowLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"多种布局方式";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatCollectionView];
    
    [self masonryLayout];
}

- (NSMutableArray<UIImage *> *)imagesArray {
    if (_imagesArray == nil) {
        _imagesArray = [NSMutableArray array];
        // 添加图片
        for (NSInteger i = 1; i < 21; i++) {
            [_imagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%zd", i]]];
        }
    }
    return _imagesArray;
}

// 创建CollectionView
- (void)creatCollectionView {
    // 定义flowlayout
    UICollectionViewLayout *lineFlowLayout = [[MICircleLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lineFlowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // 注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.changeButton];
    [self.changeButton setTitle:@"点俺切换布局" forState:UIControlStateNormal];
    self.changeButton.backgroundColor = [UIColor orangeColor];
    [self.changeButton addTarget:self action:@selector(changeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeButtonAction:(UIButton *)button {
    if ([self.collectionView.collectionViewLayout isKindOfClass:[MIGirdLayout class]]) {
        MILineLayout *lineLayout = [[MILineLayout alloc] init];
        lineLayout.itemSize = CGSizeMake(100, 100);
        [self.collectionView setCollectionViewLayout:lineLayout  animated:YES];
        
    } else if ([self.collectionView.collectionViewLayout isKindOfClass:[MICircleLayout class]]) {
        MIGirdLayout *gird = [[MIGirdLayout alloc] init];
        [self.collectionView setCollectionViewLayout:gird animated:YES];
        
    } else {
        [self.collectionView setCollectionViewLayout:[[MICircleLayout alloc] initWithDelegate:self] animated:YES];
    }
}

// 代码约束布局
- (void)masonryLayout {
    // 集合view
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 代码约束布局
        make.top.equalTo(self.view.mas_top).offset(0.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.bottom.equalTo(self.changeButton.mas_top).offset(0.0f);
    }];
    // 改变button
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(0.0f);
        make.height.offset(100.0f);
    }];
}

#pragma mark - 实现
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArray.count;
}

// 生成item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor blueColor];
    cell.contentView.layer.contents = (id)self.imagesArray[indexPath.item].CGImage;
    
    cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.contentView.layer.borderWidth = 5;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中某个ITEM的时候");
    // 参考demo中 选中item后从数组中删除
    //[self.imagesArray removeObjectAtIndex:indexPath.item];
    // 删除item
    //[self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
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
