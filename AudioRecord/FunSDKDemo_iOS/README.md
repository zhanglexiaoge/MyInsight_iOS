# FunSDKDemo_iOS
FunSDK(手机客户端SDK)Demo for iOS

## 开发环境

|系统工具|最低版本|
|--|--|
|Mac OS | 10.13.6|     
|XCODE | 9.4.1|

## 开发准备
 第一次使用FunSDKDemo之前，请先登录雄迈开放平台，http://docs-open.xmeye.net/#/  并仔细阅读新手指南和各项说明。 
	
## 替换最新的FunSDK.Framework

GitHub下载的代码，supporting/library文件夹中FunSDK.Framework可能是错误或者不是最新的，可以去开放平台上面下载最新的FunSDK.Framework来替换。  
- 下载地址：http://docs-open.xmeye.net/#/downloadcenter/downloadcenter-FunSDKdowmload 
- 或访问开放平台首页： https://open.xmeye.net。
	
## FunSDKDemo流程图

程序功能界面和操作流程可以参考 FunSDKDemo流程图chart.pdf 文件
![Demo](FunSDK_Demo_iOS_Guide.jpg)

## 其他说明

1. 如果想要简单快速开发，并且没有定制服务器和其他特殊的功能，那么可以直接重新开发ViewController，按照demo中的调用方式直接调用各个功能的Manager 和 Control 等功能类;
2. 如果有定制服务器和其他特殊功能，则可能需要根据定制内容进行一些修改(例如替换支持定制内容的底层库等等);
3. 如果是demo中没有的功能，首先可以根据协议尝试自己开发，如果无法实现则可以联系我们，由我们来判断是否需要在demo中添加此功能;
4. 更多功能说明请参考开放指南：http://docs-open.xmeye.net/#/FunSDKDevelopmentGuide/FunSDKDevelopmentGuide-iOSIntegration


