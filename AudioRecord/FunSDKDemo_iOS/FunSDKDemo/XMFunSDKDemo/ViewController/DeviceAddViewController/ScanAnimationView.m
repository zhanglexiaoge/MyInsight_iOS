//
//  ScanAnimationView.m
// 
//
//  Created by Megatron on 11/6/15.
//  Copyright © 2015 Megatron. All rights reserved.
//

#import "ScanAnimationView.h"

@interface ScanAnimationView ()
{
    __block CGFloat _addHeight;
}

@property (nonatomic,strong) UIImageView *bgImage;     // 背景图片
@property (nonatomic,strong) UIImageView *moveView;    // 扫描横线

@end
@implementation ScanAnimationView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.bgImage = [[UIImageView alloc] initWithFrame:self.bounds];
        self.bgImage.image = [UIImage imageNamed:@"scan_round.png"];
        
        [self addSubview:self.bgImage];
        
        CGFloat myWidth = self.bounds.size.width;
        CGFloat myBorder = 5;
        self.moveView = [[UIImageView alloc] initWithFrame:CGRectMake(myBorder, myBorder, myWidth - myBorder * 2, 6)];
//        self.moveView.backgroundColor = [UIColor colorWithRed:44/255.0 green:248/255.0 blue:152/255.0 alpha:1];
        self.moveView.image = [UIImage imageNamed:@"scan_move_line"];
        
        [self addSubview:self.moveView];
    }
    
    return self;
}

//开始扫描动画
-(void)startScanAnimation
{
    self.moveView.hidden = NO;
    CGFloat myWidth = self.bounds.size.width;
    CGFloat myBorder = 5;
    
    _addHeight = self.moveView.frame.origin.y;
    
    if (_addHeight >= self.frame.size.height - myBorder) {
        _addHeight = myBorder - 10;
    }
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(){
        self.moveView.frame = CGRectMake(myBorder, _addHeight + 10, myWidth - myBorder * 2, 6);
    }completion:^(BOOL ifCompeleted)
    {
        if (ifCompeleted) {
            [self startScanAnimation];
        }
    }];
}

@end
