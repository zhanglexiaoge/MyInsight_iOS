//
//  DrawBaseVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "DrawBaseVC.h"

@interface DrawBaseVC ()

@end

@implementation DrawBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIView *)redView {
    if (!_redView) {
        UIView *redView = [[self.drawViewClass alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - 140)];
        [self.view addSubview:redView];
        _redView = redView;
        redView.backgroundColor = [UIColor whiteColor];
    }
    return _redView;
}

- (Class)drawViewClass {
    return [UIView class];
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
