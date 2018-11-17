//
//  TheXibPage.m
//  MergeProjectFramework
//
//  Created by Clement_Gu on 16/8/26.
//  Copyright © 2016年 clement. All rights reserved.
//

#import "TheXibPage.h"

@implementation TheXibPage
/**
 *  关联Xib 这边有至少5种以上的方法去关联一个view的Xib，但是一般都是纯代码编码还不是很熟练就写一个简单的吧
 注意点这边的bundle是用的[self class]而不是mainbundle
 *
 *  @return 返回的是Xib的界面
 */
+(instancetype)viewFromNib
{
    //这边是返回数组的第一个view 即xib的view
    return [[NSBundle bundleForClass:[self class]]loadNibNamed:@"TheXibPage" owner:nil options:nil][0];
}

/**
 *  这边是xib设置属性布局的地方
 */
-(void)awakeFromNib
{
    
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
}


@end
