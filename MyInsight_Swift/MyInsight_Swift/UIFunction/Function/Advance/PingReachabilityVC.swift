//
//  PingReachabilityVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/3/7.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit

class PingReachabilityVC: UIViewController {

   let pinger: SimplePing = SimplePing(hostName: "www.apple.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.testPingReachability()
    }
    
    // MARK: 测试Ping是否可以OK
    func testPingReachability() -> Void {
        
        pinger.addressStyle = SimplePingAddressStyle.icmPv4
        pinger.delegate = self
        // 开始
        pinger.start()
    }
}

// MARK: 实现代理协议方法
extension PingReachabilityVC: SimplePingDelegate {
    // 解析 HostName 拿到 ip 地址之后，发送封包
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        debugPrint("解析 HostName 拿到 ip 地址之后，发送封包")
        // 发送数据
        pinger.send(with: address)
    }
    
    // ping 功能启动失败
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        debugPrint("ping 功能启动失败 \(error)")
        // 局域网ping数据失败 在这里
    }
    
    // ping 成功发送封包
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        debugPrint("ping 成功发送封包")
    }
    
    // ping 发送封包失败
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        debugPrint("ping 发送封包失败 \(error)")
    }
    
    // ping 发送封包之后收到响应
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        debugPrint("ping 发送封包之后收到响应")
    }
    
    // ping 接收响应封包发生异常
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        debugPrint("ping 接收响应封包发生异常")
    }
}

/*
 [iOS ping - SimplePing 源码解读](https://www.jianshu.com/p/106e35daff87)
 */
