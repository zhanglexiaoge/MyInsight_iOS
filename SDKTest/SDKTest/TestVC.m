//
//  TestVC.m
//  SDKTest
//
//  Created by SongMenglong on 2018/12/3.
//  Copyright © 2018 happylong. All rights reserved.
//

#import "TestVC.h"

@interface TestVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"测试Test";
    
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
