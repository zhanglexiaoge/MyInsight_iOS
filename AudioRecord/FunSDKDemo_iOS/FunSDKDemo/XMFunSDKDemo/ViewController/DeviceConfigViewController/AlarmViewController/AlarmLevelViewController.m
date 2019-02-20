//
//  AlarmLevelViewController.m
//  FunSDKDemo
//
//  Created by Levi on 2018/5/23.
//  Copyright © 2018年 Levi. All rights reserved.
//

#import "AlarmLevelViewController.h"

@interface AlarmLevelViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *levelArray;

@property (nonatomic, strong) UITableView *levelTableView;

@end

@implementation AlarmLevelViewController

-(UITableView *)levelTableView{
    if (!_levelTableView) {
        _levelTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*3+64) style:UITableViewStylePlain];
        _levelTableView.delegate = self;
        _levelTableView.dataSource = self;
        [_levelTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _levelTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置导航栏
    [self setNaviStyle];
    
    //配置子视图
    [self configSubView];
    
}

-(void)setNaviStyle{
    self.navigationItem.title = TS("Alarm_Sensitivity");
}

-(void)configSubView{
    self.levelArray = @[TS("Alarm_Lower"),TS("Alarm_Middle"),TS("Alarm_Anvanced")];
    [self.view addSubview:self.levelTableView];
}

#pragma mark -- UITableViewDelegate/DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.levelArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.alarmLevelBlock) {
        self.alarmLevelBlock(self.levelArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:NO];
}
@end
