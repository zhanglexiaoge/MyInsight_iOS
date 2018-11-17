//
//  ViewController.m
//  TheTestFrameWork
//
//  Created by Clement_Gu on 16/8/26.
//  Copyright © 2016年 clement. All rights reserved.
//

#import "ViewController.h"
//这边导入的是framework自带的头文件因为在头文件里面关联了 也可以直接导入需要的文件
#import <FrameworkBuild/FrameworkBuild.h>
//这边是导入storyboard的framework
#import <TestStoryboardAndConectionFramewrok/TestStoryboardAndConectionFramewrok.h>
//这边是导入的图片和Xib的framework
#import <MergeProjectFramework/MergeProjectFramework.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self buildAllControls];
    
}
/**
 *  创建界面
 */
-(void)buildAllControls
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 250, 50)];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn setTitle:@"测试framework是否正常运行" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *storyboard = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 250, 50)];
    [storyboard setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [storyboard setTitle:@"测试storyboard是否正常运行" forState:UIControlStateNormal];
    [storyboard addTarget:self action:@selector(storyboardClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:storyboard];
    
    UIButton *XibAndPicture = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 250, 50)];
    [XibAndPicture setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [XibAndPicture setTitle:@"测试图片和Xib是否正常运行" forState:UIControlStateNormal];
    [XibAndPicture addTarget:self action:@selector(XibAndPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:XibAndPicture];

    
    
}

/**
 *  基本的类方法
 */
-(void)btnClick
{
    //调用类方法
    [HellowWorld alert];
}

/**
 *  storyboard的类方法
 */
-(void)storyboardClick
{
    //调用storboard
    [ThemanagerStoryBorad managerTheInitPage:self.navigationController];
}

/**
 *  检测图片和xib 这里注意了 我这边的xib的头文件没有暴露出来但是还是可以运行的
 */
-(void)XibAndPicture
{
    MainViewController *xibAndPicture = [[MainViewController alloc]init];
    [self.navigationController pushViewController:xibAndPicture animated:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
