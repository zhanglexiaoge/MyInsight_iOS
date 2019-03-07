//
//  BaseVC.swift
//  MyInsight_Swift
//
//  Created by SongMengLong on 2018/9/30.
//  Copyright © 2018 SongMengLong. All rights reserved.
//

import UIKit
import Alamofire
import AFNetworking

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationController?.view.backgroundColor = UIColor.blue
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain , target: nil, action: nil)
        
        
        //debugPrint("网络状态::: \(NetworkReachabilityManager()!.isReachable)")
//        debugPrint("AF网络状态::: \(AFNetworkReachabilityManager.shared().isReachable)")
        //debugPrint("网络状态::: \(AppBackgroundService().isReachable)")
        
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
