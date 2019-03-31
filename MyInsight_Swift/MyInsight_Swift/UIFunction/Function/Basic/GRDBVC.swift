//
//  GRDBVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/3/31.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit
import GRDB

//let dbQueue = try DatabaseQueue(path: "/path/to/database.sqlite")
//let dbPool = try DatabasePool(path: "/path/to/database.sqlite")

class GRDBVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.grdbTest()
    }
    
    
    // MARK: - 数据库测试
    func grdbTest() -> Void {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
