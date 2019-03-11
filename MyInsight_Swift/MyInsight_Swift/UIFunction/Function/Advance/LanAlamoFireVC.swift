//
//  LanAlamoFireVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/3/11.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit
import Alamofire

class LanAlamoFireVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Alamofire.request("https://www.baidu.com/", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).response {
            (response) in
            if (response.error == nil) {
                debugPrint("请求成功")
                debugPrint(response.request!.value as Any)
            } else {
                // 请求返回还是慢
                debugPrint("请求失败\(String(describing: response.error))")
            }
        }
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
