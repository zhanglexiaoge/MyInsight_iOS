//
//  MainRearVC.swift
//  MyInsight_Swift
//
//  Created by SongMengLong on 2018/7/22.
//  Copyright © 2018年 SongMengLong. All rights reserved.
//

import UIKit
import SWRevealViewController

class MainRevealVC: SWRevealViewController {
    
    //  iOS之UI--使用SWRevealViewController 实现侧边菜单功能详解实例 https://www.cnblogs.com/LiLihongqiang/p/5905547.html
    override func viewDidLoad() {
        super.viewDidLoad()
        // 主页面
        let tabbarVC: TabBarVC = TabBarVC()
        // 左边侧滑页面
        let rearRevealVC: RearRevealVC = RearRevealVC()
        // 右边侧滑页面
        let rightRevealVC: RightRevealVC = RightRevealVC()
        // 左右抽屉显示宽度
        self.rearViewRevealWidth = UIScreen.main.bounds.size.width*0.70
        self.rightViewRevealWidth = UIScreen.main.bounds.size.width*0.70
        
        // 添加手势
        tabbarVC.view.isUserInteractionEnabled = true
        tabbarVC.view.addGestureRecognizer(self.panGestureRecognizer())
        tabbarVC.view.addGestureRecognizer(self.tapGestureRecognizer())
        
        // 主页面
        self.frontViewController = tabbarVC
        // 左侧面
        self.rearViewController = rearRevealVC
        // 右侧面
        self.rightViewController = rightRevealVC
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
