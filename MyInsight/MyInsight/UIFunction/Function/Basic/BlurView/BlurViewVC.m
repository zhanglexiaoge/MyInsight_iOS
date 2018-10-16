
//
//  BlurViewVC.m
//  MyInsight
//
//  Created by SongMengLong on 2018/6/25.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "BlurViewVC.h"
#import "UIImage+Blur.h"

@interface BlurViewVC ()

@property(nonatomic,retain)UIImageView *imageView;

@end

@implementation BlurViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"毛玻璃效果";
    
    self.imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIImage *image = [UIImage imageNamed:@"testPic.jpg"];
    [self.view addSubview:self.imageView];
    self.imageView.image = [image boxblurImageWithBlur:0.4];
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
