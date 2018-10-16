//
//  MyBlogVC.swift
//  MyInsight_Swift
//
//  Created by SongMengLong on 2018/10/3.
//  Copyright © 2018 SongMengLong. All rights reserved.
//

import UIKit

class MyBlogVC: BaseVC {
    
    var tableView = UITableView()
    
    var dataArray: Array<String> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的博客"
        
        self.tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        // 注册cell
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        // 清空多余cell
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.dataArray = ["iOS面试题", "一些", "SDWebImage原理", "一些指令", "多线程", "NSDictionary实现原理", "Block底层实现原理", "model", "Category", "Blog", "iOS面试之道"]
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

extension MyBlogVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
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
