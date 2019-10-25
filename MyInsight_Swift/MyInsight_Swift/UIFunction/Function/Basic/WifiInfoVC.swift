

//
//  WifiInfoVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/7/10.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork

/*获取Wi-Fi信息*/
class WifiInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let ssid = self.getUsedSSID()
        debugPrint("当前的Wi-Fi名字:\(ssid)")
        let address = self.GetIPAddresses()
        debugPrint("当前的Wi-Fi地址: \(String(describing: address))")
        
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.view.addSubview(button)
        //button.isEnabled = true
        button.addTarget(self, action: #selector(buttonAction), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor.gray
        
    }
    
    @objc func buttonAction() -> Void {
        debugPrint("这是什么字符串??? ")
        debugPrint("UUID字符串", UUID().uuidString)
    }
    
    
    // 获取Wi-Fi名称
    func getUsedSSID() -> String {
        let interfaces = CNCopySupportedInterfaces()
        var ssid = ""
        if interfaces != nil {
            let interfacesArray = CFBridgingRetain(interfaces) as! Array<AnyObject>
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    ssid = interfaceData["SSID"]! as! String
                }
            }
        }
        return ssid
    }
    
    
    //MARK: - 获取IP
    public func GetIPAddresses() -> String? {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        debugPrint("\(addresses)")
        return addresses.first
    }
    
    func getIPAddress() -> String {
        var address = ""
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
//        if getifaddrs(&ifaddr) == 0 {
//            // For each interface ...
//
//            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
//                let interface = ptr.memory
//                // Check for IPv4 or IPv6 interface:
//                let addrFamily = interface.ifa_addr.memory.sa_family
//                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//                    // Check interface name:
//                    if let name = String.fromCString(interface.ifa_name), name == "en0" {
//                        // Convert interface address to a human readable string:
//                        var addr = interface.ifa_addr.memory
//                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
//                        getnameinfo(&addr, socklen_t(interface.ifa_addr.memory.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
//                        address = String.fromCString(hostname)!
//                    }
//                }
//            } freeifaddrs(ifaddr)
//
//        }
//        var ad = ["0", "0", "0", "0"]
//        ad = address.components(separatedBy: ".")
//        // 把获取到的手机IP拆分开放到数组ad中
//        ad[3] = "1" // 将最后一位强制修改为1
//        address = ad[0] + "." + ad[1] + "." + ad[2] + "." + ad[3] // 再把修改后的ad数组组合成String
//        print(address) // 看看修改结果
//        return address // 返回值
        
        return ""
        
    }
}
