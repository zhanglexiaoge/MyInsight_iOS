//
//  ColorPickerUnitSlider.h
//  MyInsight
//
//  Created by SongMengLong on 2018/7/16.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPickerUnitSlider : UIControl

@property (nonatomic, strong) UIImageView *sliderKnobView;

@property (nonatomic, assign) BOOL horizontal;

@property (nonatomic, assign) CGFloat value;

@end
