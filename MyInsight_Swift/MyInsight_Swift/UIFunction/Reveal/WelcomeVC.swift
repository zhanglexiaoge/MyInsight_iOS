//
//  WelcomeVC.swift
//  MyInsight_Swift
//
//  Created by SongMengLong on 2018/7/22.
//  Copyright © 2018年 SongMengLong. All rights reserved.
//

import UIKit

class WelcomeVC: BaseVC {
    // 滑动view
    var scrollView: UIScrollView = UIScrollView()
    // 页面控制
    var pageControl: UIPageControl = UIPageControl()
    // 图片数组
    var pageArray: NSArray = NSArray()
    
    // 欢迎页面
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white;
        
        self.pageArray = ["launch_0", "launch_1", "launch_2", "launch_3"]
        
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.view.addSubview(self.scrollView)
        
        
        
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
