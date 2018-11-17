//
//  ThemanagerStoryBorad.m
//  TestStoryboardAndConectionFramewrok
//
//  Created by Clement_Gu on 16/8/25.
//  Copyright © 2016年 clement. All rights reserved.
//

#import "ThemanagerStoryBorad.h"
#import "StoryboardTestViewController.h"


@implementation ThemanagerStoryBorad

//另外这边拉控件是为了检测拉控件链接的属性是否有效
/**
 *  类方法对接外部view
 *
 *  @param basePage 这边是用外部的navigation来进行跳转的 也可以用viewController 这要看跳转的形式 如果用tabbar的可以选择切换跟控制器
 */
+(void)managerTheInitPage:(UINavigationController *)basePage
{
    //因为在frame里面其bundle实frame不是工程文件所以这边bundle要按一下写
    NSBundle *mainBundler = [NSBundle bundleForClass:[self class]];
    //切换storyboard
    UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"TestStoryboard" bundle:mainBundler];
    //设置storyboard的启动视图
    StoryboardTestViewController *vc = [stroyboard instantiateViewControllerWithIdentifier:@"test"];
    [basePage pushViewController:vc animated:YES];
}

@end
