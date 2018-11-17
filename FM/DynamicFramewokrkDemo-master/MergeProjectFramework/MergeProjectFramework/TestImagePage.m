
//
//  TestImagePage.m
//  createAXib
//
//  Created by Clement_Gu on 16/8/24.
//  Copyright © 2016年 clement. All rights reserved.
//

#import "TestImagePage.h"

@implementation TestImagePage


/**
 *  图片页面的构造函数
 *
 *  @param frame 位置
 *
 *  @return 返回view
 */
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建图片
        UIImageView *imageView = [[UIImageView alloc]init];
        //同样这边图片是放在Assets.xcassets里面的
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        //这边是从bundle中获取的图像资源
        imageView.image = [UIImage imageNamed:@"用户头像" inBundle:bundle compatibleWithTraitCollection:nil];
        //设置图片的位置
        imageView.frame = CGRectMake(100, 100, 50, 50);
        [self addSubview:imageView];
    }
    return self;
}


@end
