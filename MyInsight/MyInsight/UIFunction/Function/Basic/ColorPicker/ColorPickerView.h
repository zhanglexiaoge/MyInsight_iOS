//
//  ColorPickerView.h
//  MyInsight
//
//  Created by SongMengLong on 2018/7/16.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerHSWheel.h"
#import "ColorPickerBrightnessSlider.h"
#import "ColorPickerAlphaSlider.h"
#import "ColorPickerSwatchView.h"

@interface ColorPickerView : UIControl

@property (nonatomic, strong) ColorPickerHSWheel *colorWheel;
// 亮度滑动条
@property (nonatomic, strong) ColorPickerBrightnessSlider *brightnessSlider;
// 透明度滑动条
@property (nonatomic, strong) ColorPickerAlphaSlider *alphaSlider;
// 现在颜色指示器
@property (nonatomic, strong) ColorPickerSwatchView *currentColorIndicator;

@property (nonatomic, strong) NSMutableArray *swatches;
// 选中颜色
@property (nonatomic, strong) UIColor *selectedColor;
// 旧颜色
@property (nonatomic, strong) UIColor *oldColor;
// 展示
@property (nonatomic, assign) BOOL displaySwatches;



@end
