//
//  AppBackgroundService.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/3/6.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit
import Alamofire

class AppBackgroundService: NSObject {
    
    // 监听网络状态
    var isReachable: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    override init() {
        super.init()
        
        NetworkReachabilityManager()?.listener = { status in
            switch status {
            case .notReachable:
                print("网络状态判断 notReachable")
            case .unknown:
                print("网络状态判断 unknown")
            case .reachable(.ethernetOrWiFi):
                print("网络状态判断 ethernetOrWiFi")
            case .reachable(.wwan):
                print("网络状态判断 wwan")
            }
            
            // 发送通知
        }
        // 开始监听网络
        NetworkReachabilityManager()?.startListening()
    }
    
}
