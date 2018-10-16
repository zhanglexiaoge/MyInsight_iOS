//
//  DataBaseVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/2/1.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "DataBaseVC.h"
#import "SQLiteDBVC.h"
#import "RealmDBVC.h"
#import "FMDBVC.h"
#import "CoreDataVC.h"

@interface DataBaseVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

static const NSString *SQLiteStr = @"SQLite数据库";
static const NSString *RealmStr = @"Realm数据库";
static const NSString *FMDB_Str = @"FMDB数据库";
static const NSString *CoreDataStr = @"CoreData数据库";

@implementation DataBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"数据库";
    
    self.dataArray = @[SQLiteStr, RealmStr, FMDB_Str, CoreDataStr];
    
    [self creatTableView];
}

#pragma mark - 创建
- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        //cell = [[[NSBundle mainBundle]loadNibNamed:@"MineCell" owner:self options:nil] lastObject];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    // 赋值
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取字符串
    NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([cellString isEqual:SQLiteStr]) {
        // SQLite
        SQLiteDBVC *sqliteDBVC = [[SQLiteDBVC alloc] init];
        sqliteDBVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sqliteDBVC animated:YES];
    }
    if ([cellString isEqual:RealmStr]) {
        // RealmDB
        RealmDBVC *realmDBVC = [[RealmDBVC alloc] init];
        realmDBVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:realmDBVC animated:YES];
    }
    if ([cellString isEqual:FMDB_Str]) {
        // FMDBVC
        FMDBVC *fmdbVC = [[FMDBVC alloc] init];
        fmdbVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fmdbVC animated:YES];
    }
    if ([cellString isEqual:CoreDataStr]) {
        // CoreData
        CoreDataVC *coreDataVC = [[CoreDataVC alloc] init];
        coreDataVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:coreDataVC animated:YES];
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
