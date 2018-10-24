#  iOS第三方库工具

### [CocoaPods]()

1. 查看ruby源
`gem sources -l`

2. 移除掉原有的源
`gem sources --remove https://rubygems.org/`

3. 添加国内最新的源，ruby-china。之前有用淘宝的源
`gem sources -a https://gems.ruby-china.org`

4. 检查是否添加成功
`gem sources -l`

5. 安装cocoapods
`sudo gem install -n /usr/local/bin cocoapods`

6. 安装完成后查看pod版本
`pod --version`

7. 添加Podfile文件
` pod init`

8. 安装第三方库
`pod install`

更新仓库
`pod update` 
`pod update --verbose`
更新所有的仓库
`pod repo update --verbose`
更新制定的仓库
`pod update ** --verbose --no-repo-update`

禁止升级 CocoaPods 的 spec 仓库，否则会卡在 Analyzing dependencies，非常慢
`pod update --verbose --no-repo-update`

更新CocoaPods版本

删除CocoaPods仓库

CocoaPods常见错误



### [Carthage](https://github.com/Carthage/Carthage)
目标：Carthage旨在使用最简单的方式来管理Cocoa框架。
原理：自动将第三方框架编译为动态库(Dynamic framework)
优点：Carthage为用户管理第三方框架和依赖，但不会自动修改项目文件或构建设置，开发者可以完全控制项目结构和设置
缺点：只支持iOS 8.0+，不能用来开发iOS 8.0以前的项目


使用Carthage
1. 先进入项目所在的文件夹
`cd '项目路径'`
2. 创建一个Carthage空文件
`touch Cartfile`
3. 编辑Cartfile文件，例如要安装MBProgressHUD框架
`github "jdg/MBProgressHUD" ~> 1.0.0`
4. 保存并关闭Cartfile文件，使用Carthage安装框架
`carthage update`

### 参考：
[CocoaPods使用总结](https://www.jianshu.com/p/7d0ad4cde012)

[Carthage 的使用——iOS第三方库的管理](https://www.jianshu.com/p/f33972b08648)

[CocoaPods 都做了什么？](https://github.com/Draveness/analyze/blob/master/contents/CocoaPods/CocoaPods%20%E9%83%BD%E5%81%9A%E4%BA%86%E4%BB%80%E4%B9%88%EF%BC%9F.md)
