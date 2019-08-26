//
//  BasicVC.swift
//  MyInsight_Swift
//
//  Created by SongMengLong on 2018/7/22.
//  Copyright © 2018年 SongMengLong. All rights reserved.
//

import UIKit
import SWRevealViewController

class BasicVC: BaseVC {
    let RunTimeStr = "RunTime"
    let ClosureStr = "Closure"
    let GRDBStr = "GRDB数据库"
    let AES_Crypto = "AES加密"
    let GCD_Group = "GCD调度组"
    let WifiInfo = "WiFi信息"
    let DatePick = "日期选择"
    let TimePick = "时间选择"
    
    // 声明变量
    let tableview = UITableView()
    // 数组
    fileprivate lazy var dataArray = { () -> [String] in
        let array = [RunTimeStr, ClosureStr, GRDBStr, AES_Crypto, GCD_Group, WifiInfo, DatePick, TimePick]
        return array
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 设置抽屉手势
        if self.revealViewController() != nil {
            self.revealViewController().tapGestureRecognizer()
           // 添加手势动作
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 设置抽屉手势
        if self.revealViewController() != nil {
            // 移除掉手势动作
        self.view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 左右button 设置抽屉
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "左边", style: UIBarButtonItem.Style.plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))) //revealToggle(_:)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "右边", style: UIBarButtonItem.Style.plain, target: self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)))
        
        self.view.backgroundColor = UIColor.white
        self.tableview.backgroundColor = UIColor.white
        
        // 可以写swift的一些特性
        let name: String? = "老王"
        
        let name1:String? = nil
        
        // ?? 运算符的优先级低于 +号，注意使用的时候加上括号啊
        
        print(name ?? "" + "你好")
        
        print(name1 ?? "" + "你好")
        
        // 初始化tableview
        self.view.addSubview(self.tableview)
        self.tableview.frame = self.view.bounds;
        self.tableview.delegate = self
        self.tableview.dataSource = self
        // 注册cell
        self.tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        // 清空多余cell
        self.tableview.tableFooterView = UIView(frame: CGRect.zero)
        
//        dataArray = [RunTimeStr, ClosureStr, GRDBStr, AES_Crypto, GCD_Group, WifiInfo]
        // 303030434246324335453435
        // hex值转换十六进制
        let str: String = String(data: Data(hex: "303030434246324335453435"), encoding: String.Encoding.utf8)!
        
        debugPrint("转换后的字符串内容", str)
        
        var tempStr = ""
        
//        for index in 0...5 {
//            print("\(index) 乘于 5 为：\(index * 5)")
//            // str = str + string.substring(with: NSMakeRange(0,2)).uppercased()
//            tempStr = tempStr + str.prefix(upTo: <#T##String.Index#>)
//        }
        
        
        let x = "000CBF2C5E45"
        
        var newText = String()
        for (index, character) in x.enumerated() {
            if index != 0 && index % 2 == 0 {
                newText.append(":")
            }
            newText.append(String(character))
        }
        print(newText)
        
        
        let s = "000CBF2C5E45"
        let r = String(s.enumerated().map { $0 > 0 && $0 % 2 == 0 ? [":", $1] : [$1]}.joined())
        
        print(r)
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

//MARK: - 实现协议
extension BasicVC: UITableViewDelegate, UITableViewDataSource {
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
                
        if cellStr == RunTimeStr {
            // RunTime运行时
            let runTimeVC :RunTimeVC = RunTimeVC()
            runTimeVC.title = RunTimeStr
            runTimeVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(runTimeVC, animated: true)
        }
        if cellStr == ClosureStr {
            // 闭包
            let closureVC: ClosureVC = ClosureVC()
            closureVC.title = ClosureStr
            closureVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(closureVC, animated: true)
        }
        if cellStr == GRDBStr {
            // GRDB数据库
            let grdbVC: GRDBVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GRDBVC") as? GRDBVC)!
            grdbVC.title = GRDBStr
            grdbVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(grdbVC, animated: true)
        }
        if cellStr == AES_Crypto {
            // AES加密
            let aesVC = CryptoAESVC()
            aesVC.title = AES_Crypto
            aesVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(aesVC, animated: true)
        }
        if cellStr == GCD_Group {
            // GCD调度组
            let gcdGroupVC = GCDGroupVC()
            gcdGroupVC.title = GCD_Group
            gcdGroupVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(gcdGroupVC, animated: true)
        }
        if cellStr == WifiInfo {
            // Wi-Fi信息
            let wifiInfoVC = WifiInfoVC()
            wifiInfoVC.title = WifiInfo
            wifiInfoVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(wifiInfoVC, animated: true)
        }
        if cellStr == DatePick {
            // 日期选择
            let datePickerVC = DatePickerVC()
            datePickerVC.hidesBottomBarWhenPushed = true
            //self.navigationController?.pushViewController(datePickerVC, animated: true)
            datePickerVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            self.present(datePickerVC, animated: true) {
                
            }
        }
        if cellStr == TimePick {
            // 时间选择
            let timePickerVC = TimePickerVC()
            timePickerVC.hidesBottomBarWhenPushed = true
            //self.navigationController?.pushViewController(timePickerVC, animated: true)
            timePickerVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            self.present(timePickerVC, animated: true) {
                
            }
        }
    }
}
