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
