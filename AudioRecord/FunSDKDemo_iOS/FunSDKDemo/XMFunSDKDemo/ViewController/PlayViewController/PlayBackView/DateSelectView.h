//
//  DateSelectView.h
//  XMEye
//
//  Created by XM on 2017/3/20.
//  Copyright © 2017年 Megatron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateSelectViewDelegate <NSObject>
-(void)dateSelectedAction:(BOOL)Result;
@end
@interface DateSelectView : UIView

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, assign) id <DateSelectViewDelegate> delegate;

-(void)dateSelectVIewShow;
@end
