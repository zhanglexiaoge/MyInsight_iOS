//
//  SQLiteHandle.m
//  MyInsight
//
//  Created by SongMenglong on 2018/2/24.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "SQLiteHandle.h"
#import <sqlite3.h> // 数据库
#import "DataBaseModel.h"

@interface SQLiteHandle()

@end

@implementation SQLiteHandle

/*
 数据库处理工具
 
 */

#pragma mark - 创建单例
+ (instancetype)shareDataHandle {
    static SQLiteHandle *dataHandle = nil;
    if (dataHandle == nil) {
        dataHandle = [[SQLiteHandle alloc] init];
    }
    return dataHandle;
}

#pragma mark - 创建一个数据库对象
static sqlite3 *db;

#pragma mark - 打开数据库
- (void)openSQLiteDB {
    NSLog(@"%@", NSHomeDirectory());
    /* 1.创建数据库文件路径 */
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SLZ.sqlite"];
    
    /* 判断: 当数据已经打开 直接返回 */
    if (db != nil) {
        return;
    }
    
    /* 2. 将数据库文件和数据库对象进行关联(即打开数据库) */
    int result = sqlite3_open(dbPath.UTF8String, &db);
    
    /* 3. 根据函数的返回值, 输出相应的信息 */
    if (SQLITE_OK == result) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
}

#pragma mark - 创建表格
- (void)creatTable {
    /* 1. 创建SQL语句 */
    NSString *creatSQL = @"CREATE  TABLE IF NOT EXISTS shuaishuai (number INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, pic TEXT, source TEXT)";
    
    /* 2. 通过函数, 对数据库进行SQL语句操作 */
    int result = sqlite3_exec(db, creatSQL.UTF8String, NULL, NULL, NULL);
    
    /* 3. 通过函数返回值, 输出相应信息 */
    if (SQLITE_OK == result) {
        NSLog(@"成功创建表格");
    } else {
        NSLog(@"创建表格失败");
    }
}

#pragma mark - 插入信息
- (void)insertModel:(DataBaseModel *)model {
    /* 1.创建SQL语句 */
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO shuaishuai (name, pic, source) VALUES('%@', '%@', '%@')", model.name, model.pic, model.source];
    
    /* 2. 通过函数执行SQL操作 */
    int result = sqlite3_exec(db, insertSQL.UTF8String, NULL, NULL, NULL);
    if (SQLITE_OK == result) {
        NSLog(@"成功插入表格");
    } else {
        NSLog(@"插入表格失败");
    }
}

#pragma mark - 删除信息
- (void)deleteWithName:(NSString *)name {
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM shuaishuai WHERE name = '%@'", name];
    int result = sqlite3_exec(db, deleteSQL.UTF8String, NULL, NULL, NULL);
    if (SQLITE_OK == result) {
        NSLog(@"成功删除信息");
    } else {
        NSLog(@"删除信息失败");
    }
}

#pragma mark - 查询信息
- (NSArray *)selectModel {
    /* 1. 创建一个数组, 用于存放符合条件的数据 */
    NSMutableArray *arr = [NSMutableArray array];
    
    /* 2. sql语句 */
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM shuaishuai"];
    
    /* 核心API: sqlite3_stmt */
    /* 3.1 创建 准备好的语句对象(stmt) */
    sqlite3_stmt *stmt = nil;
    
    /* 3.2 编译SQL语句 */
    int result = sqlite3_prepare_v2(db, selectSQL.UTF8String, -1, &stmt, NULL);
    if (SQLITE_OK == result) {
        
        /* 3.3 逐行进行查询
         * 当sqlite3_step()函数返回值为SQLITE_ROW时, 说明还有数据可以查询
         */
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            /* 如何要对查询结果需要操作, 调用sqlite3_column函数簇 */
            
            /**
             * @param 1: stmt对象
             * @param 2: 要提取值所在的列(从0开始)
             */
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            const unsigned char *pic = sqlite3_column_text(stmt, 2);
            const unsigned char *source = sqlite3_column_text(stmt, 3);
            
            /* 3.4 创建student对象, 进行赋值, 之后放到数组里面 */
            DataBaseModel *model = [[DataBaseModel alloc] init];
            model.name = [NSString stringWithUTF8String:(const char *)name];
            model.pic = [NSString stringWithUTF8String:(const char *) pic];
            model.source = [NSString stringWithUTF8String:(const char *) source];
            
            [arr addObject:model];
        }
        /* 3.5 销毁stmt对象 */
        sqlite3_finalize(stmt);
    } else {
        
        sqlite3_finalize(stmt);
    }
    
    return arr;
}

#pragma mark - 查询信息
- (NSArray *)selectModeltWithName:(NSString *)name {
    /* 1. 创建一个数组, 用于存放符合条件的数据 */
    NSMutableArray *arr = [NSMutableArray array];
    
    /* 2. sql语句 */
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM shuaishuai WHERE name = '%@'", name];
    /* 核心API: sqlite_3stmt */
    /* 3.1 创建 准备好的语句对象(stmt) */
    sqlite3_stmt *stmt = nil;
    
    /* 3.2 编译SQL语句 */
    int result = sqlite3_prepare_v2(db, selectSQL.UTF8String, -1, &stmt, NULL);
    if (SQLITE_OK == result) {
        
        /* 3.3 逐行进行查询
         * 当sqlite3_step()函数返回值为SQLITE_ROW时, 说明还有数据可以查询
         */
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            /* 如何要对查询结果需要操作, 调用sqlite3_column函数簇 */
            
            /**
             * @param 1: stmt对象
             * @param 2: 要提取值所在的列(从0开始)
             */
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            
            /* 3.4 创建student对象, 进行赋值, 之后放到数组里面 */
            DataBaseModel *model = [[DataBaseModel alloc] init];
            model.name = [NSString stringWithUTF8String:(const char *) name];
            [arr addObject:model];
        }
        /* 3.5 销毁stmt对象 */
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
    }
    return arr;
}

#pragma mark - 删除表格
- (void)dropTable {
    NSString *dropSQL = @"DROP  TABLE IF EXISTS shuaishuai";
    int result = sqlite3_exec(db, dropSQL.UTF8String, NULL, NULL, NULL);
    if (SQLITE_OK == result) {
        NSLog(@"成功删除表格");
    } else {
        NSLog(@"删除表格失败");
    }
}

@end
