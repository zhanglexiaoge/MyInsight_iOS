//
//  RadioButton.h
//  MyInsight
//
//  Created by SongMenglong on 2018/3/13.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButton : UIButton

// 取消或者确定block 默认NO=cancel YES=enter
typedef void (^ ClickedAction)(RadioButton *button, BOOL selected);

// block属性
@property (nonatomic, copy) ClickedAction clickedAction;

@end
