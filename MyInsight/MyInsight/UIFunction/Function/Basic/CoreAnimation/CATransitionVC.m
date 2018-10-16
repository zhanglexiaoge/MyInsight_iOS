//
//  CATransitionVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/23.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CATransitionVC.h"
#import <Masonry.h>

@interface CATransitionVC ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation CATransitionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CATransition转场动画";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    static int i = 2;
    
    // 转场代码
    if (i == 4) {
        i = 1;
    }
    // 加载图片名称
    NSString *imageN = [NSString stringWithFormat:@"CATransition%d",i];
    
    self.imageView.image = [UIImage imageNamed:imageN];
    
    i++;
    
    // 转场动画
    CATransition *anim = [CATransition animation];
    
    anim.type = @"pageCurl";
    
    anim.duration = 2;
    
    [_imageView.layer addAnimation:anim forKey:nil];
}

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self.view addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(90, 20, 20, 20));
        }];
    }
    return _imageView;
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
