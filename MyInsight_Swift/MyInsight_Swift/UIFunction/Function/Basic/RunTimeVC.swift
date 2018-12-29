
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
        
        let string1: String = "12356789"
        debugPrint(string1.suffix(4))
        
        debugPrint(string1.count)
        debugPrint("gemCloudProtoco".count)
        debugPrint("gemCloudProtoco200442".count)
        
        let string2 = "gemCloudProtoco200442{\"command\":\"up\",\"devices\":[{\"active\":1,\"dev_class_type\":\"fresh_air_system\",\"dev_id\":158,\"dev_key\":1,\"dev_name\":\"坚稳新风\",\"dev_state\":\"{\\\"co2\\\":\\\"0.642\\\",\\\"humidity\\\":\\\"30.00\\\",\\\"outside_temp\\\":\\\"0.00\\\",\\\"pm25\\\":\\\"26.00\\\",\\\"status\\\":\\\"off\\\",\\\"sur1\\\":\\\"61\\\",\\\"temperature\\\":\\\"21.00\\\",\\\"value\\\":1}\",\"online\":1,\"room_name\":\"客厅\"}],\"from_account\":\"941050368520442a090e\",\"from_role\":\"devconn\",\"msg_type\":\"device_state_info\",\"pro_ver\":\"1.1\"}"
        
        
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
