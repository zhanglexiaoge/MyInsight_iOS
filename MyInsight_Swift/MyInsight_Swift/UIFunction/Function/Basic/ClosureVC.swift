//
//  ClosureVC.swift
//  MyInsight_Swift
//
//  Created by SongMengLong on 2018/10/9.
//  Copyright © 2018 SongMengLong. All rights reserved.
//

import UIKit

class ClosureVC: BaseVC {

    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 闭包
        
        creatTableView()
        
        self.perform(#selector(nameSettter), with: nil, afterDelay: 3.0)
        
    }
    
    
    @objc func nameSettter() -> Void {
        debugPrint("执行测试方法")
    }
    
    
    
    
    
    func creatTableView() -> Void {
        //
        tableView = UITableView(frame: view.bounds, style: UITableView.Style.plain)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.isEditing = true // 可编辑
        
        // 注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        // 清空cell
        tableView.tableFooterView = UIView(frame: CGRect.zero)
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

extension ClosureVC: UITableViewDelegate, UITableViewDataSource{
    //MARK: - 实现TableView的代理方法
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消执行方法
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    
    // 设置可编辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 设置删除类型
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    // 修改按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            print("就要删除了...")
            // 进行删除操作
            
        }
    }
}
