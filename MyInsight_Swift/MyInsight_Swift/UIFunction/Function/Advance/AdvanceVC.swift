//
//  AdvanceVC.swift
//  MyInsight_Swift
//
//  Created by SongMengLong on 2018/7/22.
//  Copyright © 2018年 SongMengLong. All rights reserved.
//

import UIKit
import SWRevealViewController

class AdvanceVC: BaseVC {
    
    // 声明变量
    let tableview = UITableView()
    // 数组
    var dataArray = Array<String>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 抽屉
        if self.revealViewController() != nil {
            self.revealViewController().tapGestureRecognizer()
            // 添加手势动作
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.revealViewController() != nil {
            // 移除掉手势动作
            self.view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航栏
        naviBarSetting()
        
        //debugPrint(self.decTobin(number: 451))
        
//        debugPrint(451 & (0x1 << 0) >> 0)
//        debugPrint(451 & (0x1 << 1) >> 1)
//        debugPrint(451 & (0x1 << 2) >> 2)
//        debugPrint(451 & (0x1 << 3) >> 3)
//        debugPrint(451 & (0x1 << 4) >> 4)
//        debugPrint(451 & (0x1 << 5) >> 5)
//        debugPrint(451 & (0x1 << 6) >> 6)
//        debugPrint(451 & (0x1 << 7) >> 7)
        
        // 分割成二进制
        debugPrint(String(451, radix: 2))
        
//
        let zifuchuang = String(451, radix: 2)

        //debugPrint(zifuchuang.suffix(3))
        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.startIndex, offsetBy: 0)])
        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.startIndex, offsetBy: 1)])
        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.startIndex, offsetBy: 2)])
        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.startIndex, offsetBy: 3)])
        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.startIndex, offsetBy: 4)])
        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.startIndex, offsetBy: 5)])
        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.startIndex, offsetBy: 6)])
        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.startIndex, offsetBy: 7)])
        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.startIndex, offsetBy: 8)])
//
//        debugPrint("?????????????????????")
//        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.endIndex, offsetBy: -1)])
//        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.endIndex, offsetBy: -2)])
//        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.endIndex, offsetBy: -3)])
//        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.endIndex, offsetBy: -4)])
//        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.endIndex, offsetBy: -5)])
//        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.endIndex, offsetBy: -6)])
//        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.endIndex, offsetBy: -7)])
//        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.endIndex, offsetBy: -8)])
//        debugPrint(zifuchuang[zifuchuang.index(zifuchuang.endIndex, offsetBy: -9)])
//
//        debugPrint("#####################")
        
        
        // 初始化tableview
        self.view.addSubview(self.tableview)
        self.tableview.frame = self.view.bounds;
        self.tableview.delegate = self
        self.tableview.dataSource = self
        // 注册cell
        self.tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        // 清空多余cell
        self.tableview.tableFooterView = UIView(frame: CGRect.zero)
        
        dataArray = ["视频采集", "相机人脸"]
    }

    // 设置导航栏
    func naviBarSetting() -> Void {
        // 左右button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "左边", style: UIBarButtonItem.Style.plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))) //revealToggle(_:)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "右边", style: UIBarButtonItem.Style.plain, target: self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)))
    }

}


//MARK: - 实现协议
extension AdvanceVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // cell行数目
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    // 生成cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        // label赋值
        cell.textLabel?.text = dataArray[indexPath.row]
        // 箭头
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell
    }
    // 选中cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellStr: String = self.dataArray[indexPath.row]
        
        // VideoCapture
        
        if cellStr == "视频采集" {
            // RunTime运行时
            let videoCaptureVC: VideoCaptureVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoCaptureVC") as! VideoCaptureVC
            videoCaptureVC.title = "视频采集"
            videoCaptureVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(videoCaptureVC, animated: true)
        }
        if cellStr == "相机人脸" {
            // RunTime运行时
            let cameraFaceVC: CameraFaceVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraFaceVC") as! CameraFaceVC
            cameraFaceVC.title = "相机人脸"
            cameraFaceVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(cameraFaceVC, animated: true)
        }
        
    }
}



extension AdvanceVC {
    func bitConvert() -> Void {
        // swift进制间的转换
        // 按位取数
//        debugPrint(38&0b00000001)
//        debugPrint(38&0b00000010)
//        debugPrint(38&0b00000100)
//        debugPrint(38&0b00001000)
//        debugPrint(38&0b00010000)
//        debugPrint(38&0b00100000)
//        debugPrint(38&0b01000000)
//        debugPrint(38&0b10000000)
        
    }
    
    
    func decTobin(number:Int) -> String {
        var num = number
        var str = ""
        while num > 0 {
            str = "\(num % 2)" + str
            debugPrint(str)
            num /= 2
        }
        return str
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}



