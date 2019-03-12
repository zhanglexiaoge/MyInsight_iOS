
//
//  PDFLoaderVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/3/11.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit

class PDFLoaderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let pdfFilePath = Bundle.main.path(forResource: "compressed.tracemonkey-pldi-09", ofType: "pdf")
        self.loadPDFFile(filePath: pdfFilePath!)
        
    }
    
    // MARK: 加载PDF
    func loadPDFFile(filePath: String) -> Void {
        let webView = UIWebView(frame: self.view.bounds)
        self.view.addSubview(webView)
        

        let viwerPath: String = Bundle.main.path(forResource: "viewer", ofType: "html")! // , inDirectory: "generic/web"
        // %@?file=%@#page=1
        var urlStr = viwerPath + "?file=\(filePath)#page=1"
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let request = URLRequest(url: URL(string: urlStr)!)
        webView.loadRequest(request)
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


class PDFWebView: UIWebView {
    
    
    
}

