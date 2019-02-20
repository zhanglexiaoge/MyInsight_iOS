//
//  PasswordSaveViewController.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/2.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "PasswordSaveViewController.h"
#import "UserInfoCell.h"

@interface PasswordSaveViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;  //账号密码列表
@property (nonatomic, strong) NSMutableDictionary *dataDic;//数据字典

@end

@implementation PasswordSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
    
    //设置导航栏
    [self configNav];
    
    //获取本地用户名和密码数据
    [self getLocalData];
}

#pragma mark - 设置导航栏
-(void)configNav
{
    self.navigationItem.title = TS("user_psw");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *cleatBtn = [[UIBarButtonItem alloc] initWithTitle:TS("delete") style:UIBarButtonItemStyleDone target:self action:@selector(cleatBtnClicked)];
    self.navigationItem.rightBarButtonItem = cleatBtn;
    cleatBtn.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - 获取本地用户名和密码数据
-(void)getLocalData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.dataDic = [[defaults objectForKey:@"UserInfo"] mutableCopy];
}

#pragma mark - EventAction
#pragma mark 返回上一层
-(void)backItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 清空所有数据
-(void)cleatBtnClicked
{
    [self.dataDic removeAllObjects];
    [self.mainTableView reloadData];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.dataDic forKey:@"UserInfo"];
}

#pragma mark 删除某一行数据，并刷新列表
-(void)deleteData:(NSString *)userName
{
    [self.dataDic removeObjectForKey:userName];
    [self.mainTableView reloadData];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.dataDic forKey:@"UserInfo"];
}

#pragma mark - tableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataDic.allKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *useName = [self.dataDic.allKeys objectAtIndex:indexPath.row];
    NSString *passWord = [self.dataDic objectForKey:useName];
    cell.mainTitle.text = useName;
    cell.descriptionTitle.text = passWord;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteData:[self.dataDic.allKeys objectAtIndex:indexPath.row]];
    }
}

#pragma mark - lazyLoad 懒加载
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, ScreenHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
        _mainTableView.estimatedRowHeight = 0;
        [_mainTableView registerClass:[UserInfoCell class] forCellReuseIdentifier:@"UserInfoCell"];
        
        _mainTableView.tableFooterView = [UIView new];
    }
    return _mainTableView;
}

-(NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    return _dataDic;
}

@end
