
//
//  BlogListVC.swift
//  MyInsight_Swift
//
//  Created by SongMengLong on 2018/9/30.
//  Copyright © 2018 SongMengLong. All rights reserved.
//

import UIKit

class BlogListVC: BaseVC {
    
    var tableView: UITableView = UITableView()
    
    var dataArray: Array<String> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "博客列表"
        self.view.backgroundColor = UIColor.white
        
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // 注册cell
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        // 清空多余cell
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        view.addSubview(self.tableView)
        
        self.dataArray = ["验证试验 - 探求 fishhook 原理（二）", "巧用符号表 - 探求 fishhook 原理（一）", "Mach-O 文件格式探索", "Shadowsocks Probe I - Socks5 与 EventLoop 事件分发", "Shadowsocks Probe II - TCP 代理过程", "Swift Probe - Optional", "AutoLayout 中的线性规划 - Simplex 算法", "用 isa 承载对象的类信息", "objc_msgSend消息传递学习笔记 - 消息转发", "objc_msgSend消息传递学习笔记 - 对象方法消息传递流程", "浅谈Associated Objects", "weak 弱引用的实现方式", "load 方法全程跟踪", "浅谈 block（2） - 截获变量方式", "浅谈 block（1） - clang 改写后的 block 结构", "CFArray 的历史渊源及实现原理", "Run Loop 记录与源码注释", "复用的精妙 - UITableView 复用技术原理分析", "从经典问题来看 Copy 方法", "SDWebImage Source Probe - Downloader", "SDWebImage Source Probe - Operation", "SDWebImage Source Probe - WebCache", "SDWebImage Source Probe - Manager", "iOS面试题"]
        
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

extension BlogListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        //cell.backgroundColor = UIColor.orange
        
        cell.textLabel?.text = dataArray[indexPath.row]
        // 箭头
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let markdownStr: String = dataArray[indexPath.row]
        debugPrint("滚滚长江东逝水 " + markdownStr)
        let markDownBlogVC :MarkDownBlogVC = MarkDownBlogVC()
        markDownBlogVC.hidesBottomBarWhenPushed = true
        markDownBlogVC.markdownStr = markdownStr
        self.navigationController?.pushViewController(markDownBlogVC, animated: true)
        
    }
    
}
