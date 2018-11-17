//
//  TestClass.swift
//  SMLKit
//
//  Created by gemvary_mini_2 on 2018/11/17.
//  Copyright © 2018 SongMengLong. All rights reserved.
//

import UIKit

open class TestClass: NSObject {

    open class func backViewController() -> UIViewController {
        // 获取bundle
        // [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource:@“你bundle的名字” ofType: @"bundle"]];
        
        let resourceRooturl = "FrameWork/SMLKit.framework"
        
        
        //let bundlePath = Bundle.main.path(forResource: "SMLBundle", ofType: "bundle")
        
        let bundle = Bundle(path: resourceRooturl+"SMLBundle.bundle")
        
        let mainVC: UIViewController = UIStoryboard(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "MainVC") as UIViewController
        
        
        return UIViewController()
    }
    
    
}
