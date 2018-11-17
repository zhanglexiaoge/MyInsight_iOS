//
//  MainViewController.m
//  MergeProjectFramework
//
//  Created by Clement_Gu on 16/8/24.
//  Copyright © 2016年 clement. All rights reserved.
//

#import "MainViewController.h"
#import "TheXibPage.h"
#import "TestImagePage.h"
@interface MainViewController ()
@property (nonatomic,strong)UIView *view1;
@property (nonatomic,strong)UIView *view2;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildAllControls];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
/**
 *  创建界面
 */
-(void)buildAllControls
{
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    [btn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"framework图片的额接入" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 200, 50)];
    [btn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"frameworkXib的接入" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}
/**
 *  图片演示
 */
-(void)btn1Click {
    TestImagePage *imageView = [[TestImagePage alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    imageView.backgroundColor = [UIColor orangeColor];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [imageView addGestureRecognizer:tap];
    self.view1 = imageView;
    [self.view addSubview:imageView];
    
    
}
/**
 *  xib演示
 */
- (void)btn2Click {
    TheXibPage *xibView  = [TheXibPage viewFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [xibView addGestureRecognizer:tap];
    self.view2 = xibView;
    [self.view addSubview:xibView];
    
}

-(void)dismiss
{
    if (self.view1 != nil) {
        [self.view1 removeFromSuperview];
    }
    if (self.view2 != nil) {
        [self.view2 removeFromSuperview];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
