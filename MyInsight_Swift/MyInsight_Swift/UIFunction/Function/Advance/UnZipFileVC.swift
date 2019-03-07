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
        
        let myZipFilePath = Bundle.main.path(forResource: "weex_lan", ofType: "zip")
        print(myZipFilePath!)
        //let documentDirectoryURL =  try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        
        let documentDirectoryURL =  try! FileManager().url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        print("Documents dir:")
        print(documentDirectoryURL.path)
        //SSZipArchive.unzipFileAtPath(myZipFilePath, toDestination: documentDirectoryURL.path)
        let status = SSZipArchive.unzipFile(atPath: myZipFilePath!, toDestination: documentDirectoryURL.path)
        print("Zip file unzipped! \(status)")
        
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
