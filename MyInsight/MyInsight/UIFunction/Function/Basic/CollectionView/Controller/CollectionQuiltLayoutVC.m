
//
//  CollectionQuiltLayoutVC.m
//  MyInsight
//
//  Created by SongMengLong on 2018/7/9.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CollectionQuiltLayoutVC.h"
#import "MIQuiltLayout.h"
#import <Masonry.h>

@interface CollectionQuiltLayoutVC ()<MIQuiltLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    BOOL isAnimating;
}
// 集合View
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *numbers;
@property (nonatomic) NSMutableArray *numberWidths;
@property (nonatomic) NSMutableArray *numberHeights;

// 添加button
@property (nonatomic, strong) UIButton *addButton;
// 移除button
@property (nonatomic, strong) UIButton *removeButton;
// 重载button
@property (nonatomic, strong) UIButton *reloadButton;

@end

int num = 0;

@implementation CollectionQuiltLayoutVC

- (void) viewDidAppear:(BOOL)animated {
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"自定义布局";
    
     [self datasInit];
    //
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.addButton];
    self.addButton.backgroundColor = [UIColor orangeColor];
    [self.addButton setTitle:@"Add" forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.removeButton];
    self.removeButton.backgroundColor = [UIColor orangeColor];
    [self.removeButton setTitle:@"Remove" forState:UIControlStateNormal];
    [self.removeButton addTarget:self action:@selector(removeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.reloadButton];
    self.reloadButton.backgroundColor = [UIColor orangeColor];
    [self.reloadButton setTitle:@"Reload" forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(reloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64.0f+10.0f);
        make.left.equalTo(self.view.mas_left).offset(10.0f);
        make.width.offset(80.0f);
        make.height.offset(30.0f);
    }];
    
    [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64.0f+10.0f);
        make.left.equalTo(self.addButton.mas_right).offset(10.0f);
        make.width.offset(80.0f);
        make.height.offset(30.0f);
    }];
    
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64.0f+10.0f);
        make.right.equalTo(self.view.mas_right).offset(-10.0f);
        make.width.offset(80.0f);
        make.height.offset(30.0f);
    }];
    
    MIQuiltLayout* layout = [[MIQuiltLayout alloc] init];
    layout.direction = UICollectionViewScrollDirectionVertical; // 方向
    layout.blockPixels = CGSizeMake(75,75);
    layout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64.0f+10.0f+30.0f+10.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(0.0f);
    }];
    // 注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    [self.collectionView reloadData];
}

// 添加button动作方法
- (void)addButtonAction:(UIButton *)button {
    NSLog(@"添加动作");
    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
    if (visibleIndexPaths.count == 0) {
        [self addIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        return;
    }
    NSUInteger middle = (NSUInteger)floor(visibleIndexPaths.count / 2);
    NSIndexPath *toAdd = [visibleIndexPaths firstObject];[visibleIndexPaths objectAtIndex:middle];
    [self addIndexPath:toAdd];
}

// 移除button的动作方法
- (void)removeButtonAction:(UIButton *)button {
    NSLog(@"移除动作");
    if (!self.numbers.count) {
        return;
    }
    
    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *toRemove = [visibleIndexPaths objectAtIndex:(arc4random() % visibleIndexPaths.count)];
    [self removeIndexPath:toRemove];
}

// 重载button的动作方法
- (void)reloadButtonAction:(UIButton *)button {
    NSLog(@"重载动作");
    [self datasInit];
    [self.collectionView reloadData];
}

- (void)datasInit {
    num = 0;
    self.numbers = [@[] mutableCopy];
    self.numberWidths = @[].mutableCopy;
    self.numberHeights = @[].mutableCopy;
    for(; num<15; num++) {
        //NSLog(@"........ %d ", num);
        [self.numbers addObject:@(num)];
        [self.numberWidths addObject:@([self randomLength])];
        [self.numberHeights addObject:@([self randomLength])];
    }
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self removeIndexPath:indexPath];
}

- (UIColor*)colorForNumber:(NSNumber*)num {
    return [UIColor colorWithHue:((19 * num.intValue) % 255)/255.f saturation:1.f brightness:1.f alpha:1.f];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"选中cell %lu", (unsigned long)self.numbers.count);
    return self.numbers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [self colorForNumber:self.numbers[indexPath.row]];
    //cell.backgroundColor = [UIColor redColor];
    
    UILabel* label = (id)[cell viewWithTag:5];
    if(!label) label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    label.tag = 5;
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%@", self.numbers[indexPath.row]];
    label.backgroundColor = [UIColor clearColor];
    [cell addSubview:label];
    
    return cell;
}

#pragma mark – RFQuiltLayoutDelegate
-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row >= self.numbers.count) {
        NSLog(@"Asking for index paths of non-existant cells!! %ld from %lu cells", (long)indexPath.row, (unsigned long)self.numbers.count);
    }
    
    CGFloat width = [[self.numberWidths objectAtIndex:indexPath.row] floatValue];
    CGFloat height = [[self.numberHeights objectAtIndex:indexPath.row] floatValue];
    //NSLog(@"小方块的高度什么的：%f %f", width, height);
    return CGSizeMake(width, height);
    
    //    if (indexPath.row % 10 == 0)
    //        return CGSizeMake(3, 1);
    //    if (indexPath.row % 11 == 0)
    //        return CGSizeMake(2, 1);
    //    else if (indexPath.row % 7 == 0)
    //        return CGSizeMake(1, 3);
    //    else if (indexPath.row % 8 == 0)
    //        return CGSizeMake(1, 2);
    //    else if(indexPath.row % 11 == 0)
    //        return CGSizeMake(2, 2);
    //    if (indexPath.row == 0) return CGSizeMake(5, 5);
    //
    //    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

#pragma mark - 帮助方法
- (void)addIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.numbers.count) {
        return;
    }
    
    if(isAnimating) return;
    isAnimating = YES;
    
    [self.collectionView performBatchUpdates:^{
        NSInteger index = indexPath.row;
        [self.numbers insertObject:@(++num) atIndex:index];
        [self.numberWidths insertObject:@(1 + arc4random() % 3) atIndex:index];
        [self.numberHeights insertObject:@(1 + arc4random() % 3) atIndex:index];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } completion:^(BOOL done) {
        self->isAnimating = NO;
    }];
}

- (void)removeIndexPath:(NSIndexPath *)indexPath {
    if(!self.numbers.count || indexPath.row > self.numbers.count) return;
    
    if(isAnimating) return;
    isAnimating = YES;
    
    [self.collectionView performBatchUpdates:^{
        NSInteger index = indexPath.row;
        [self.numbers removeObjectAtIndex:index];
        [self.numberWidths removeObjectAtIndex:index];
        [self.numberHeights removeObjectAtIndex:index];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } completion:^(BOOL done) {
        self->isAnimating = NO;
    }];
}

- (NSUInteger)randomLength {
    // always returns a random length between 1 and 3, weighted towards lower numbers.
    NSUInteger result = arc4random() % 6;
    
    if (result <= 2) {
        // 3/6 chance of it being 1.
        result = 1;
    } else if (result == 5) {
        // 1/6 chance of it being 3.
        result = 3;
    } else {
        // 2/6 chance of it being 2.
        result = 2;
    }
    
    return result;
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
