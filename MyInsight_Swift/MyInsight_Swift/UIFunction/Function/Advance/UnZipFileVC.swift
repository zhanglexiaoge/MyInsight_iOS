//
//  UnZipFileVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/3/7.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit
import SSZipArchive

class UnZipFileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.white
        
        self.unArchiveZip()
    }
    
    
    // MARK: 解压缩zip包
    func unArchiveZip() -> Void {
        // zip包的路径
        let myZipFilePath = Bundle.main.path(forResource: "weex_lan", ofType: "zip")
        print(myZipFilePath!)
        
        //解压的目标路径
        let documentDirectoryURL =  try! FileManager().url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        
        let fileArray = try! FileManager.init().contentsOfDirectory(atPath: documentDirectoryURL.path)
        if fileArray.contains("weex_lan") == false {
            let status = SSZipArchive.unzipFile(atPath: myZipFilePath!, toDestination: documentDirectoryURL.path)
            print("Zip file unzipped! \(status)")
        }
        let weex_lanPath = documentDirectoryURL.appendingPathComponent("weex_lan/dist")
        debugPrint("解压后的路径内容: \(weex_lanPath)")
        
        
        
        let weex_lanArray = try! FileManager.init().contentsOfDirectory(atPath: weex_lanPath.path)
        
        debugPrint("解压后的路径内容AAAA : \(weex_lanArray)")
        
        print(documentDirectoryURL.path)
        // 解压zip包
        
        debugPrint("AAAA: \(try! FileManager.init().contentsOfDirectory(atPath: documentDirectoryURL.path))")
        // 解压后文件夹路径
        
    }

}
