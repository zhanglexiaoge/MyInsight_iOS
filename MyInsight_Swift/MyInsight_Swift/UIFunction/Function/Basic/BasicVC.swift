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
    
    // 声明变量
    let tableview = UITableView()
    // 数组
    var dataArray = Array<String>()
    
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
        
        dataArray = [RunTimeStr, ClosureStr]
        
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
        
        
    }
}
