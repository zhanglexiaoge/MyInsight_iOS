//
//  MILineLayout.h
//  MyInsight
//
//  Created by SongMenglong on 2018/4/17.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class MILineFlowLayout;

@protocol MILineFlowLayoutDelegate <NSObject>
@optional

@end

@interface MILineLayout : UICollectionViewFlowLayout

- (instancetype)initWithDelegate:(id<MILineFlowLayoutDelegate>)delegate;

+ (instancetype)lineLayoutWithDelegate:(id<MILineFlowLayoutDelegate>)delegate;

@end
