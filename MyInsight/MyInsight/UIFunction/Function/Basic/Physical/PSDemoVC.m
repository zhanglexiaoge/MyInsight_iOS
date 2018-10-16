
//
//  PSDemoVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/24.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "PSDemoVC.h"
#import <Masonry.h>
#import "PSBaseView.h"
#import "PSSnapView.h"
#import "PSPushView.h"
#import "PSAttachmentView.h"
#import "PSSpringView.h"
#import "PSCollisionView.h"

@interface PSDemoVC ()

@end

@implementation PSDemoVC

/*
 仿真：Physical Simulation
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PSBaseView *baseView = nil;
    switch (self.function) {
        case FunctionSnap:
            baseView = [[PSSnapView alloc] init];
            self.title = @"吸附行为";
            break;
        case FunctionPush:
            baseView = [[PSPushView alloc] init];
            self.title = @"推动行为";
            break;
        case FunctionAttachment:
            baseView = [[PSAttachmentView alloc] init];
            self.title = @"刚性附着行为";
            break;
        case FunctionSpring:
            baseView = [[PSSpringView alloc] init];
            self.title = @"弹性附着行为";
            break;
        case FunctionCollision:
            baseView = [[PSCollisionView alloc] init];
            self.title = @"碰撞测试";
            break;
        default:
            break;
    }
    
    [self.view addSubview:baseView];
    
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(40 + 10, 10, 10, 10));
    }];
    
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
