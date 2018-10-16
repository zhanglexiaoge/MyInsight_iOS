//
//  UIImage+Blur.h
//  MyInsight
//
//  Created by SongMengLong on 2018/6/25.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (Blur)

-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;

@end
