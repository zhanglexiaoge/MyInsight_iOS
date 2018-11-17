//
//  TestClass.swift
//  IconButton
//
//  Created by gemvary_mini_2 on 2018/11/17.
//  Copyright © 2018 GuessMe. All rights reserved.
//

import UIKit

public class TestClass: NSObject {
    
    public class func creatTestVC() -> Void {
        //#define MYBUNDLE_NAME_2 @"bundle1.bundle"
        //#define MYBUNDLE_PATH_2 [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME_2]
        //#define MYBUNDLE_2 [NSBundle bundleWithPath: MYBUNDLE_PATH_2]
        
        let MYBUNDLE_NAME_2: String? = "FrameWork/IconButton.framework/IconButtonBundle.bundle"
        debugPrint(MYBUNDLE_NAME_2 as Any)
        let MYBUNDLE_PATH_2: String? = Bundle.main.resourcePath?.appending(MYBUNDLE_NAME_2!)
        debugPrint(MYBUNDLE_PATH_2 as Any)
        let MYBUNDLE_2: Bundle? = Bundle(path: MYBUNDLE_PATH_2!)
        debugPrint(MYBUNDLE_2 as Any)
        
        /*
         [Framework&&Bundle打包&&iOS SDK](https://www.jianshu.com/p/92876a275f7f)
         
         
         [iOS | 在framework中打包和使用bundle](https://www.jianshu.com/p/ad07419980c7)
         [iOS打包framework - Swift完整项目打包Framework，嵌入OC项目使用](https://www.cnblogs.com/yajunLi/p/5987687.html)
         [xcode7制作framework,结合xib,storyboard,资源文件等](https://www.jianshu.com/p/038dab7accbc)
         [iOS 如何给FrameWork添加Image, Xib文件](https://blog.csdn.net/qq_28865297/article/details/77508791)
         [iOS 打包.framework(包括第三方、图片、xib、plist文件)详细步骤及需要注意的地方](http://www.cnblogs.com/yk123/p/9340268.html)
         
         http://docs-open.xmeye.net/#/downloadcenter/downloadcenter-FunSDKdowmload
         */
        
        
        
    }
    
}
