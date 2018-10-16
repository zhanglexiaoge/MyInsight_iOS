//
//  MIBezierPath.h
//  MyInsight
//
//  Created by SongMengLong on 2018/6/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIBezierPath : UIBezierPath
/** color */
@property (nonatomic,strong)UIColor *color;

/** setColor */
-(void)setColor:(UIColor *)color;

@end
