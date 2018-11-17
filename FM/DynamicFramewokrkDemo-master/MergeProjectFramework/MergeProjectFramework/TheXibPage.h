//
//  TheXibPage.h
//  MergeProjectFramework
//
//  Created by Clement_Gu on 16/8/26.
//  Copyright © 2016年 clement. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheXibPage : UIView
/**
 *  关联Xib 这边有至少5种以上的方法去关联一个view的Xib，但是一般都是纯代码编码还不是很熟练就写一个简单的吧
    注意点这边的bundle是用的[self class]而不是mainbundle
 *
 *  @return 返回的是Xib的界面
 */
+(instancetype)viewFromNib;

@end
