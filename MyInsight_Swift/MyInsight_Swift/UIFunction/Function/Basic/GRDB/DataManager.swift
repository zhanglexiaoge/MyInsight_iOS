//
//  DataManager.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/9/17.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import GRDB

class DataManager: NSObject {

    let kSmartHomeDBName = "smartHome_1.db"
    
    // 创建单例
    private static let manger: DataManager = DataManager()
    // 返回单例
    class func shareManger() -> DataManager {
        return manger
    }
    
    // 数据库地址
    lazy var dbPath: String = {
        // 根据传入的数据库名称拼接数据库的路径
        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/\(kSmartHomeDBName)")
        
        print("数据库地址：", filePath as Any)
        return filePath!
    }()
    
    /// 数据库 用于对数据库进行操作
    lazy var dbPool: DatabasePool = {
        let db = try! DatabasePool(path: dbPath)
        return db
    }()
    
    /// 数据库 用于多线程事务处理
    lazy var dbQueue: DatabaseQueue = {
        let db = try! DatabaseQueue(path: dbPath)
        return db
    }()
    
    /// 数据库表升级
    
}

/*
 http://swift-salaryman.com/grdb.php
 
 Swift SQLite ORM 框架 - GRDB.swift 使用
 https://blog.csdn.net/a794561799/article/details/94492714#_334
 
 GRDB.swift as a Solution for iOS Database
 https://www.netguru.com/codestories/grdb.swift-as-a-solution-for-ios-database
 
 Swift - 第三方SQLite库FMDB使用详解4（实体类与数据库表的关联映射）
 https://www.hangge.com/blog/cache/detail_2318.html
 
 */

