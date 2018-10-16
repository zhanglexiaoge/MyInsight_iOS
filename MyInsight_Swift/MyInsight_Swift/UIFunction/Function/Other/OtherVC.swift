//
//  OtherVC.swift
//  MyInsight_Swift
//
//  Created by SongMengLong on 2018/7/22.
//  Copyright © 2018年 SongMengLong. All rights reserved.
//

import UIKit
import SWRevealViewController
import SnapKit

class OtherVC: BaseVC {
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
        // 左右button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "左边", style: UIBarButtonItem.Style.plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))) //revealToggle(_:)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "右边", style: UIBarButtonItem.Style.plain, target: self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)))
        
        self.title = "其他"
        // 设置背景颜色
        self.view.backgroundColor = UIColor.white
        // 初始化tableview
        
        self.view.addSubview(self.tableview)
        self.tableview.frame = self.view.bounds;
        self.tableview.delegate = self
        self.tableview.dataSource = self
        // 注册cell
        self.tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        // 清空多余cell
        self.tableview.tableFooterView = UIView(frame: CGRect.zero)
        
        dataArray = ["博客", "我的博客"]
        
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

//MARK: - 扩展
extension OtherVC: UITableViewDelegate, UITableViewDataSource {
    // 实现代理协议
    
    // setction个数
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
        
        if cellStr == "博客" {
            debugPrint("博客")
            let blogListVC :BlogListVC = BlogListVC()
            blogListVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(blogListVC, animated: true)
        }
        
        if cellStr == "我的博客" {
            debugPrint("我的博客")
            let myBlogVC :MyBlogVC = MyBlogVC()
            myBlogVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(myBlogVC, animated: true)
        }
    }
}

