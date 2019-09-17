//
//  DataManager.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/9/17.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import GRDB

class DataManager: NSObject {

    /// 初始化
    var dbPool: DatabasePool?
    var dbQueue: DatabaseQueue?
    
    
//    func didChangesss() -> Void {
//        do {
//            dbPool = try DatabasePool(path: path)
//            dbQueue = try DatabaseQueue(path: path)
//        }catch {
//
//        }
//    }
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

