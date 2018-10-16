//
//  TabBarVC.swift
//  MyInsight_Swift
//
//  Created by SongMengLong on 2018/7/22.
//  Copyright © 2018年 SongMengLong. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    // 底部导航栏
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置背景颜色
        self.view.backgroundColor = UIColor.white
        
        // 基础
        let basicVC: BasicVC = BasicVC()
        let basicNavi: UINavigationController = UINavigationController(rootViewController: basicVC)
        
        // 进阶
        let advanceVC: AdvanceVC = AdvanceVC()
        let advanceNavi: UINavigationController = UINavigationController(rootViewController: advanceVC)
        
        // 高级
        let seniorVC: SeniorVC = SeniorVC()
        let seniorNavi: UINavigationController = UINavigationController(rootViewController: seniorVC)
        
        // 其他
        let otherVC: OtherVC = OtherVC()
        let otherNavi: UINavigationController = UINavigationController(rootViewController: otherVC)
        
        // 设置
        basicVC.tabBarItem.title = "基础"
        basicVC.title = basicVC.tabBarItem.title
        basicVC.tabBarItem.image = UIImage.init(named: "home_nor")
        basicVC.tabBarItem.selectedImage = UIImage.init(named: "home_sel")
        
        advanceVC.tabBarItem.title = "进阶"
        advanceVC.title = advanceVC.tabBarItem.title
        advanceVC.tabBarItem.image = UIImage.init(named: "mark_nor")
        advanceVC.tabBarItem.selectedImage = UIImage.init(named: "mark_sel")
        
        seniorVC.tabBarItem.title = "高级"
        seniorVC.title = seniorVC.tabBarItem.title
        seniorVC.tabBarItem.image = UIImage.init(named: "mine_nor")
        seniorVC.tabBarItem.selectedImage = UIImage.init(named: "mine_sel")
        
        otherVC.tabBarItem.title = "其他"
        otherVC.title = otherVC.tabBarItem.title
        otherVC.tabBarItem.image = UIImage.init(named: "setting_nor")
        otherVC.tabBarItem.selectedImage = UIImage.init(named: "setting_sel")
        
        self.setViewControllers([basicNavi, advanceNavi, seniorNavi, otherNavi], animated: false);
        
        // 设置徽标
        basicVC.navigationController?.tabBarItem.badgeValue = "1"
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
