//
//  ViewController.swift
//  FilesClippers
//
//  Created by SongMenglong on 2018/12/15.
//  Copyright © 2018 gemvary. All rights reserved.
//

import UIKit
import LLBlueTooth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化蓝牙管理者
        LLBlueTooth.shared.initCentralManager()
        
        LLBlueTooth.shared.scanForPeripheralsWithTime(time: 3)
        
    }
    
}

