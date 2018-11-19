//
//  MLAction.m
//  MLSDK
//
//  Created by gemvary_mini_2 on 2018/11/19.
//  Copyright © 2018 happylong. All rights reserved.
//

#import "MLAction.h"
#import "MLFirstVC.h"

@implementation MLAction


#define MYBUNDLE_NAME_2   @"bundle1.bundle"
#define MYBUNDLE_PATH_2   [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME_2]
#define MYBUNDLE_2        [NSBundle bundleWithPath: MYBUNDLE_PATH_2]


+ (UIViewController *)creatFirstVC {
    
    NSString *myBundleName = @"MLSDKBundle.bundle";
    NSString *myBundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:myBundleName];
    NSLog(@"生成的路径 %@", myBundlePath);
    NSBundle *myBundle = [NSBundle bundleWithPath:myBundlePath];
    NSLog(@"生成的bundle %@", myBundle);
    
    //加载storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SDK" bundle:myBundle];
    UIViewController *test = [storyboard instantiateViewControllerWithIdentifier:@"MLFirstVC"];
//    [self.navigationController pushViewController:test animated:YES];
//    // bundle加载图片
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    imageView.image = [UIImage imageWithContentsOfFile:[MYBUNDLE_PATH_2 stringByAppendingPathComponent:@"test.png"]];
//    [self.view addSubview:imageView];
    
    return  test; //[UIViewController new];
}







@end
