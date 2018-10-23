##  iOS开发之集成雄迈视频FunSDK步骤

### 集成步骤
一、在AppDelegate.mm文件中引入头文件`#import <FunSDK/FunSDK.h>`，在`didFinishLaunchingWithOptions`方法中初始化SDK。


二、从登录到打开设备
```
//设置用于存储设备信息等的数据配置文件
NSArray* pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
NSString* path = [pathArray lastObject];

FUN_SysInit([[path stringByAppendingString:@"/LocalDevs.db"] UTF8String]);

// //获取用户设备信息
FUN_SysGetDevList(SELF_HANDLE, [@"admin" UTF8String], [@"1234" UTF8String]);
```

在SDK回调方法`- (void)OnFunSDKResult:(NSNumber*)pParam`中做处理











### 参考:
[iOS开发之集成雄迈视频FunSDK步骤](http://www.cnblogs.com/yuhao309/p/9431894.html)
[iOS开发实时监控SDK的设置](https://www.aliyun.com/jiaocheng/378025.html)
[iOS集成雄迈视频FunSDK](https://www.jianshu.com/p/e82a607acd46)
[集成准备](http://docs-open.xmeye.net/#/FunSDKDevelopmentGuide/FunSDKDevelopmentGuide-iOSIntegration)
