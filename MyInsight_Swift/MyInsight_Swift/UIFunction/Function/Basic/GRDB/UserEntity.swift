//
//  UserEntity.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/9/18.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import GRDB

struct UserEntity: Codable {
    // ID自增
    var id: Int?
    //名字
    var name: String?
    // 年纪
    var age: Int?
    // 地址
    var address: String?
}

extension UserEntity {
    /// 声明列名表示 在 CURD 中直接使用 Columns.id/.name/.age/.address 进行操作数据
    enum Columns: String, ColumnExpression {
        case id, name, age, address
    }
}

/// 使用 TableRecord 协议, 告知操作数据表
extension UserEntity: TableRecord {
    //  数据表名字 如果不自定义 将使用默认的表名, 默认为小写开头驼峰命名 例如 UserEntity -> userEntity
    static var databaseTableName: String {
        return "user"
    }
    // 查询字段, 默认使用 *  ,  复制后将使用 id, name, age, address
    // static var databaseSelection: [SQLSelectable] = [Column("id"), Column("name"), Column("age"), Column("address")]
    // 同上 声明列名表示的方式
    static var databaseSelection: [SQLSelectable] = [Columns.id, Columns.name, Columns.age, Columns.address]
}

/// FetchableRecord 进行查询操作, 使用了Codable可以不实现init(row: Row)
/// fetch
extension UserEntity: FetchableRecord {
    // 未使用 Codable = Decodable & Encodable 协议的 需要实现init(row: Row)
    init(row: Row) {
        id = row["id"]
        name = row["name"]
        age = row[Columns.age]
        address = row[Columns.address]
    }
    
}


// insert
extension UserEntity: MutablePersistableRecord {
    
    /// 获取数据库
    static let dbQueue: DatabaseQueue = DataManager.shareManger().dbQueue
    
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container[Columns.name] = name
        container[Columns.address] = address
        container[Columns.age] = age
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = Int(rowID)
    }
    
    /// 创建表
    
    
    static func createTable() -> Void {
//        try! db.create(table: databaseTableName, temporary: false, ifNotExists: true, body: { (t) in
//            t.autoIncrementedPrimaryKey("id")
//            t.column("name", .text)
//            t.column("age", .integer)
//            t.column("address", .text)
//        })
        
        try! dbQueue.write({ (db) in
            /// 创建表格
            try! db.create(table: "", body: { (t) in
                /// 创建表格
                t.autoIncrementedPrimaryKey("id")
                t.column(Columns.address.rawValue, Database.ColumnType.text)
            })
            
            /// 
            
        })
        
    }
    
    
}



