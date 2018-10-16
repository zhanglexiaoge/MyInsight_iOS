//
//  FMDBVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/21.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "FMDBVC.h"
#import <Masonry.h>
#import "UIColor+Category.h"
#import <FMDatabase.h>

@interface FMDBVC ()
// 创建数据库
@property (nonatomic, strong) UIButton *createSQLiteButton;
// 创建表
@property (nonatomic, strong) UIButton *createTableButton;
// 添加数据
@property (nonatomic, strong) UIButton *addDataButton;
// 删除数据
@property (nonatomic, strong) UIButton *deleteDataButton;
// 修改数据
@property (nonatomic, strong) UIButton *changeDataButton;
// 查询数据
@property (nonatomic, strong) UIButton *searchDataButton;
// 删除表
@property (nonatomic, strong) UIButton *deleteTableButton;
// FMDB对象
@property (nonatomic, strong) FMDatabase *db;
// 学生标记
@property (nonatomic, assign) int mark_student;
// 沙盒路径(数据库地址)
@property (nonatomic, strong) NSString *docPath;

@end

@implementation FMDBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     FMDB与多线程之间的操作
     FMDB是iOS平台的SQLite数据库框架
     FMDB以OC的方式封装了SQLite的C语言API
     
     */
    self.title = @"FMDB数据库";
    
    [self creatContentView];
    
    [self masonryLayout];
}

- (void)creatContentView {
    // 创建数据库
    self.createSQLiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.createSQLiteButton];
    self.createSQLiteButton.backgroundColor = [UIColor RandomColor];
    [self.createSQLiteButton setTitle:@"新建数据库" forState:UIControlStateNormal];
    [self.createSQLiteButton addTarget:self action:@selector(createSQLiteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 新建表
    self.createTableButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.createTableButton];
    self.createTableButton.backgroundColor = [UIColor RandomColor];
    [self.createTableButton setTitle:@"新建表" forState:UIControlStateNormal];
    [self.createTableButton addTarget:self action:@selector(createTableButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 添加数据
    self.addDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.addDataButton];
    self.addDataButton.backgroundColor = [UIColor RandomColor];
    [self.addDataButton setTitle:@"添加数据" forState:UIControlStateNormal];
    [self.addDataButton addTarget:self action:@selector(addDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 删除数据
    self.deleteDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.deleteDataButton];
    self.deleteDataButton.backgroundColor = [UIColor RandomColor];
    [self.deleteDataButton setTitle:@"删除数据" forState:UIControlStateNormal];
    [self.deleteDataButton addTarget:self action:@selector(deleteDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 修改数据
    self.changeDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.changeDataButton];
    self.changeDataButton.backgroundColor = [UIColor RandomColor];
    [self.changeDataButton setTitle:@"修改数据" forState:UIControlStateNormal];
    [self.changeDataButton addTarget:self action:@selector(changeDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 查询数据
    self.searchDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.searchDataButton];
    self.searchDataButton.backgroundColor = [UIColor RandomColor];
    [self.searchDataButton setTitle:@"查询数据" forState:UIControlStateNormal];
    [self.searchDataButton addTarget:self action:@selector(searchDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 删除表
    self.deleteTableButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.deleteTableButton];
    self.deleteTableButton.backgroundColor = [UIColor RandomColor];
    [self.deleteTableButton setTitle:@"删除表" forState:UIControlStateNormal];
    [self.deleteTableButton addTarget:self action:@selector(deleteTableButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 1. 获取数据库文件的路径
    self.docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", self.docPath);
    
    self.mark_student = 1;
    // 设置数据库名称
    NSString *fileName = [self.docPath stringByAppendingPathComponent:@"fmdb.sqlite"];
    // 2.获取数据库
    self.db = [FMDatabase databaseWithPath:fileName];
    if ([self.db open]) {
        NSLog(@"打开数据库 成功");
    } else{
        NSLog(@"打开数据库 失败");
    }
}

#pragma mark - 新建数据库
- (void)createSQLiteButtonAction:(UIButton *)button {
    NSLog(@"新建数据库");
    // 1.获得数据库文件的路径
    NSString *fileName=[self.docPath stringByAppendingPathComponent:@"fmdb.sqlite"];
    // 2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    // 3.打开数据库
    if (db.open) {
        NSLog(@"打开数据库成功");
    } else{
        NSLog(@"打开数据库失败");
    }
}

#pragma mark - 新建表
- (void)createTableButtonAction:(UIButton *)button {
    NSLog(@"新建表");
    //3.创建表
    BOOL result = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL, sex text NOT NULL);"];
    if (result) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}

#pragma mark - 添加数据
- (void)addDataButtonAction:(UIButton *)button {
    NSLog(@"添加数据");
    //插入数据
    NSString *name = [NSString stringWithFormat:@"王子涵%@", @(self.mark_student)];
    int age = self.mark_student;
    NSString *sex = @"男";
    
    self.mark_student ++;
    
    //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
    BOOL result = [self.db executeUpdate:@"INSERT INTO t_student (name, age, sex) VALUES (?,?,?)",name,@(age),sex];
    //2.executeUpdateWithForamat：不确定的参数用%@，%d等来占位 （参数为原始数据类型，执行语句不区分大小写）
    //    BOOL result = [_db executeUpdateWithFormat:@"insert into t_student (name,age, sex) values (%@,%i,%@)",name,age,sex];
    
    //3.参数是数组的使用方式
    //    BOOL result = [_db executeUpdate:@"INSERT INTO t_student(name,age,sex) VALUES  (?,?,?);" withArgumentsInArray:@[name,@(age),sex]];
    if (result) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
    
}

#pragma mark - 删除数据
- (void)deleteDataButtonAction:(UIButton *)button {
    NSLog(@"删除数据");
    //1.不确定的参数用？来占 （后面参数必须是oc对象,需要将int包装成OC对象）
    int idNum = 11;
    BOOL result = [self.db executeUpdate:@"delete from t_student where id = ?",@(idNum)];
    //2.不确定的参数用%@，%d等来占位
    //BOOL result = [_db executeUpdateWithFormat:@"delete from t_student where name = %@",@"王子涵"];
    if (result) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

#pragma mark - 修改数据
- (void)changeDataButtonAction:(UIButton *)button {
    NSLog(@"更新数据库");
    //修改学生的名字
    NSString *newName = @"李浩宇";
    NSString *oldName = @"王子涵2";
    BOOL result = [self.db executeUpdate:@"update t_student set name = ? where name = ?",newName,oldName];
    if (result) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败");
    }
}

#pragma mark - 查询数据
- (void)searchDataButtonAction:(UIButton *)button {
    NSLog(@"查询数据");
    //查询整个表
    FMResultSet *resultSet = [self.db executeQuery:@"select * from t_student"];
    
    //根据条件查询
    //FMResultSet *resultSet = [_db executeQuery:@"select * from t_student where id < ?", @(4)];
    
    //遍历结果集合
    while ([resultSet next]) {
        int idNum = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet objectForColumn:@"name"];
        int age = [resultSet intForColumn:@"age"];
        NSString *sex = [resultSet objectForColumn:@"sex"];
        NSLog(@"学号：%@ 姓名：%@ 年龄：%@ 性别：%@",@(idNum),name,@(age),sex);
    }
}

#pragma mark - 删除表
- (void)deleteTableButtonAction:(UIButton *)button {
    NSLog(@"删除表");
    //如果表格存在 则销毁
    BOOL result = [self.db executeUpdate:@"drop table if exists t_student"];
    if (result) {
        NSLog(@"删除表成功");
    } else {
        NSLog(@"删除表失败");
    }
}

- (void)masonryLayout {
    // 创建数据库
    [self.createSQLiteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.top.equalTo(self.view.mas_top).offset(64.0f+30.0f);
    }];
    // 创建表
    [self.createTableButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.top.equalTo(self.createSQLiteButton.mas_bottom).offset(30.0f);
    }];
    // 添加数据
    [self.addDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.top.equalTo(self.createTableButton.mas_bottom).offset(30.0f);
    }];
    // 删除数据
    [self.deleteDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.top.equalTo(self.addDataButton.mas_bottom).offset(30.0f);
    }];
    // 修改数据
    [self.changeDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.top.equalTo(self.deleteDataButton.mas_bottom).offset(30.0f);
    }];
    // 查询数据
    [self.searchDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.top.equalTo(self.changeDataButton.mas_bottom).offset(30.0f);
    }];
    // 删除表
    [self.deleteTableButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.top.equalTo(self.searchDataButton.mas_bottom).offset(30.0f);
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
