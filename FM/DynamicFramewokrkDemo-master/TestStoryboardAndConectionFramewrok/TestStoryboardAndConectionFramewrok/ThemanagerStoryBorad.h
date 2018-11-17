//
//  ThemanagerStoryBorad.h
//  TestStoryboardAndConectionFramewrok
//
//  Created by Clement_Gu on 16/8/25.
//  Copyright © 2016年 clement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemanagerStoryBorad : NSObject

//另外这边拉控件是为了检测拉控件链接的属性是否有效

/**
 *  类方法对接外部view
 *
 *  @param basePage 这边是用外部的navigation来进行跳转的 也可以用viewController 这要看跳转的形式 如果用tabbar的可以选择切换跟控制器
 */
+(void)managerTheInitPage:(UINavigationController *)basePage;

@end
