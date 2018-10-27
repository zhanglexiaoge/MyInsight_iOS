
//
//  RunTimeVC.swift
//  MyInsight_Swift
//
//  Created by SongMengLong on 2018/10/9.
//  Copyright © 2018 SongMengLong. All rights reserved.
//

import UIKit

class RunTimeVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 时间格式化转换
        timeConvert()
        
    }
    
    
    func timeConvert() -> Void {
        // 时间格式化转换
        let timeStr1: String = "2018-10-11"
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // h设置时区
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        let date1: Date = dateFormatter.date(from: timeStr1)!
        print("要转换的时间", date1)
        
        let dateFormatter2 = DateFormatter.init()
        dateFormatter2.dateFormat = "yyyy日MM月dd日"
        dateFormatter2.timeZone = TimeZone(identifier: "GMT")
        let timeStr2: String = dateFormatter2.string(from: date1)
        print(timeStr2)
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
