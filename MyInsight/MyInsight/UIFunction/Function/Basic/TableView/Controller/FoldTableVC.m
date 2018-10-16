//
//  FoldTableVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/21.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "FoldTableVC.h"

@interface FoldTableVC ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FoldTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"折叠Table";
    
    [self creatTableView];
}

- (void)creatTableView {
    
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
