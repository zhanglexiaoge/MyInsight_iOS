//
//  MIQuiltLayout.h
//  MyInsight
//
//  Created by SongMengLong on 2018/7/9.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIQuiltLayoutDelegate <UICollectionViewDelegate>
@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath; // defaults to 1x1
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath; // defaults to uiedgeinsetszero
@end

@interface MIQuiltLayout : UICollectionViewLayout

@property (nonatomic, weak) IBOutlet NSObject<MIQuiltLayoutDelegate>* delegate;

@property (nonatomic, assign) CGSize blockPixels; // defaults to 100x100
@property (nonatomic, assign) UICollectionViewScrollDirection direction; // defaults to vertical

// only use this if you don't have more than 1000ish items.
// this will give you the correct size from the start and
// improve scrolling speed, at the cost of time at the beginning
@property (nonatomic) BOOL prelayoutEverything;

@end
