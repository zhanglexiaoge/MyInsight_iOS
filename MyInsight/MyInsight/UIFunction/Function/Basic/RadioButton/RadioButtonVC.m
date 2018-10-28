//
//  RadioButtonVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/3/13.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "RadioButtonVC.h"
#import "RadioButton.h"
#import <Masonry.h>
#import "ListPopVC.h"

@interface RadioButtonVC ()<UIPopoverPresentationControllerDelegate>
// 复选框button
@property (nonatomic, strong) RadioButton *testButton;
// 弹出菜单button
@property (nonatomic, strong) UIButton *listButton;
//
@property (nonatomic, strong) ListPopVC *listPopVC;

@end

@implementation RadioButtonVC

/*
 [IOS单选框RadioButton实现](https://www.jianshu.com/p/4971424c693b)
 [Radio Button——iOS单选按钮](https://www.jianshu.com/p/b349428b40ab)
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单选🔘";
    
    self.view.backgroundColor =  [UIColor whiteColor];
    
    self.testButton = [RadioButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.testButton];
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.0f);
        make.left.equalTo(self.view.mas_left).offset(40.0f);
        make.right.equalTo(self.view.mas_right).offset(-35.0f);
        make.height.offset(40.0f);
    }];
    
    [self.testButton setImage:[UIImage imageNamed:@"selectoff_btn"] forState:UIControlStateNormal];
    [self.testButton setImage:[UIImage imageNamed:@"selecton_btn"] forState:UIControlStateSelected];
    
    [self.testButton setTitle:@"滚滚长江东逝水" forState:UIControlStateNormal];
    
    [self.testButton setClickedAction:^(RadioButton *button, BOOL selected) {
        if (selected) {
            NSLog(@"选中button");
        } else{
            NSLog(@"没选中button");
        }
    }];
    
    self.listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.listButton];
    [self.listButton setTitle:@"列表按钮" forState:UIControlStateNormal];
    self.listButton.backgroundColor = UIColor.grayColor;
    [self.listButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.5f);
        make.left.equalTo(self.view.mas_left).offset(40.0f);
        make.right.equalTo(self.view.mas_right).offset(-35.0f);
        make.height.offset(40.0f);
    }];
    [self.listButton addTarget:self action:@selector(listButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    
}

- (void)rightBarButtonAction:(UIBarButtonItem *)button {
    //初始化 VC
    self.listPopVC = [[ListPopVC alloc] init];
    //设置 VC 弹出方式
    self.listPopVC.modalPresentationStyle = UIModalPresentationPopover;
    //设置依附的按钮
        self.listPopVC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    //self.listPopVC.popoverPresentationController.sourceView = (UIView *)button;
    //可以指示小箭头颜色
    self.listPopVC.popoverPresentationController.backgroundColor = [UIColor yellowColor];
    //箭头方向
    self.listPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    // 指定箭头所指区域的矩形框范围（位置和尺寸）,以sourceView的左上角为坐标原点
    // 这个可以 通过 Point 或  Size 调试位置
    // 使用导航栏的左右按钮不需要这句代码
    //Rself.listPopVC.popoverPresentationController.sourceRect = ((UIView *)button).bounds;
    //代理
    self.listPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.listPopVC animated:YES completion:nil];
}


#pragma mark - 列表
- (void)listButtonAction:(UIButton *)button {
    //初始化 VC
    self.listPopVC = [[ListPopVC alloc] init];
    //设置 VC 弹出方式
    self.listPopVC.modalPresentationStyle = UIModalPresentationPopover;
    //设置依附的按钮
    //    self.itemPopVC.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
    self.listPopVC.popoverPresentationController.sourceView = button;
    //可以指示小箭头颜色
    self.listPopVC.popoverPresentationController.backgroundColor = [UIColor yellowColor];
    //箭头方向
    self.listPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    // 指定箭头所指区域的矩形框范围（位置和尺寸）,以sourceView的左上角为坐标原点
    // 这个可以 通过 Point 或  Size 调试位置
    // 使用导航栏的左右按钮不需要这句代码
    self.listPopVC.popoverPresentationController.sourceRect = button.bounds;
    //代理
    self.listPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.listPopVC animated:YES completion:nil];
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;   //点击蒙版popover消失， 默认YES
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
