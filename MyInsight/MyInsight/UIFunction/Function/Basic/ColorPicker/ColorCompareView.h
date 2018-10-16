//
//  ColorCompareView.h
//  MyInsight
//
//  Created by SongMengLong on 2018/7/16.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorCompareView : UIControl
// 旧颜色
@property (nonatomic, retain) UIColor *oldColor;
// 新颜色
@property (nonatomic, retain) UIColor *currentColor;

@end
