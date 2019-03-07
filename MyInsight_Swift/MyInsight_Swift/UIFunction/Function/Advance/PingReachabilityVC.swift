//
//  PingReachabilityVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/3/7.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit

class PingReachabilityVC: UIViewController {

    var pinger: SimplePing = SimplePing(hostName: "www.apple.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.testPingReachability()
    }
    
    // MARK: 测试Ping是否可以OK
    func testPingReachability() -> Void {
        self.pinger.addressStyle = SimplePingAddressStyle.icmPv4
        self.pinger.delegate = self
        self.pinger.start()
        
        
        
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

extension PingReachabilityVC: SimplePingDelegate {
    // 解析 HostName 拿到 ip 地址之后，发送封包
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        
    }
    
    // ping 功能启动失败
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        
    }
    
    // ping 成功发送封包
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        
    }
    
    // ping 发送封包失败
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        
    }
    
    // ping 发送封包之后收到响应
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        
    }
    
    // ping 接收响应封包发生异常
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        
    }
}

/*
 [iOS ping - SimplePing 源码解读](https://www.jianshu.com/p/106e35daff87)
 */


