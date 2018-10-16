//
//  PSBaseView.h
//  MyInsight
//
//  Created by SongMenglong on 2018/4/24.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSBaseView : UIView

/**  方块视图  */
@property (nonatomic, weak) UIImageView *boxView;

/**  仿真者  */
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end
