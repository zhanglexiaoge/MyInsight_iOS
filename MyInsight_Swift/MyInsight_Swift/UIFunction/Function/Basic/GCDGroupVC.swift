
//
//  GCDGroupVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/6/26.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit
import Alamofire

class GCDGroupVC: UIViewController {

    var allArray: Array<Any> = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        //self.datasRequestGroup()
        self.gcdGroupHandler()
    }
    
    /// 网络请求调度组
    private func datasRequestGroup() {
        // 创建调度组
        let workingGroup = DispatchGroup()
        // 创建多列
        let workingQueue = DispatchQueue(label: "request_queue")
        
        // 模拟异步发送网络请求 A
        // 入组
        workingGroup.enter()
        workingQueue.async {
            Thread.sleep(forTimeInterval: 1)
            print("接口 A 数据请求完成")
            // 出组
            workingGroup.leave()
        }
        
        // 模拟异步发送网络请求 B
        // 入组
        workingGroup.enter()
        workingQueue.async {
            Thread.sleep(forTimeInterval: 1)
            print("接口 B 数据请求完成")
            // 出组
            workingGroup.leave()
        }
        
        print("我是最开始执行的，异步操作里的打印后执行")
        
        // 调度组里的任务都执行完毕
        workingGroup.notify(queue: workingQueue) {
            print("接口 A 和接口 B 的数据请求都已经完毕！, 开始合并两个接口的数据")
        }
    }
    
    // MARK: GCD多线程处理
    func gcdGroupHandler() -> Void {
        // 多线程线组
        let gropQueue:DispatchGroup = DispatchGroup.init()
        //
        let queue:DispatchQueue = DispatchQueue.init(label: "handleDataQueue")
        gropQueue.enter()
        self.getInfomation(gropQueue: gropQueue)
        
        gropQueue.notify(queue: DispatchQueue.main) {
            self.handleDatas()
            //gropQueue.leave()
        }
        
        /*进行界面处理*/
        gropQueue.notify(queue: queue) {
            self.updateUI()
        }
        
    }
    
    func getInfomation(gropQueue: DispatchGroup) -> Void {
        let requestUrl:String = "https://www.apiopen.top/novelApi"
        Alamofire.request(requestUrl, method: .get).responseJSON { (response) in
            if let json = response.result.value {
                let jsonDic:Dictionary<String,Any> = json as! Dictionary
                let array:Array<Any> = jsonDic["data"] as! Array
                self.allArray.append(array)
                gropQueue.leave()
                
            } else {
                gropQueue.leave()
            }
        }
    }
    
    
    /*刷新总列表*/
    func updateUI() -> Void {
        print("更新UI:\(self.allArray)")
    }
    
    /*异步线程处理数据*/
    func handleDatas() -> Void {
        print("处理数据:\(self.allArray)")
    }
    
}
