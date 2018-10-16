//
//  MICircleLayout.h
//  MyInsight
//
//  Created by SongMenglong on 2018/4/17.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MICircleLayout;
// 声明协议
@protocol MICircleLayoutDelegate <NSObject>
@optional
/**
 返回 item 的大小, 默认 64
 */
- (CGSize)circleLayout:(MICircleLayout *)circleLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 返回 item 对应的半径 , 默认120
 */
- (CGFloat)circleLayout:(MICircleLayout *)circleLayout collectionView:(UICollectionView *)collectionView radiusForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MICircleLayout : UICollectionViewLayout

- (instancetype)initWithDelegate:(id<MICircleLayoutDelegate>)delegate;

+ (instancetype)circleLayoutWithDelegate:(id<MICircleLayoutDelegate>)delegate;

@end
