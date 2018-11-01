##  iOS常见报错信息

10.18 晚发现的错误log
ld: warning: directory not found for option '-L/Users/songmenglong/Desktop/工作源代码SourceCode/weex/ios_v3/sip_smartHome_all_3_ucs/sip/SDK/ACloudLib'
ld: warning: directory not found for option '-F/Users/songmenglong/Desktop/工作源代码SourceCode/weex/ios_v3/sip_smartHome_all_3_ucs/sip/SDK/GemvarySmartHome'
ld: warning: directory not found for option '-F/Users/songmenglong/Desktop/工作源代码SourceCode/weex/ios_v3/sip_smartHome_all_3_ucs/sip/SDK/GemvarySH

$(PROJECT_DIR)/sip/SDK/GemvarySH
GemvarySH
$(PROJECT_DIR)/sip/SDK/GemvarySDK/GemvaryNetworkSDK

No such module 'GemvaryNetworkSDK'





1. 升级到XCode 10.0 原来的程序报错误：library not found for -lstdc++.6.0.9
升级到XCode 10.0 原来的程序报错误如下：
```
ld: library not found for -lstdc++.6.0.9

clang: error: linker command failed with exit code 1 (use -v to see invocation)
```
[解决方案1](https://blog.csdn.net/u011452278/article/details/82783921)

找到error，然后单击右键，选择弹出框中的Reveal in Log查看错误，发现是Xcode升级到10.0版本，原有的stdc++.6.0.9废弃了。
查找包含stdc++.6.0.9的文件字段，然后删除。
使用pod管理sdk的，需要在xxxxx.debug.xcconfig，xxxxx.release.xcconfig文件中将字段  -l"stdc++.6.0.9"  删除即可。

[解决方案2](https://www.jianshu.com/p/3afd5e8cdbf8)
[解决Xcode10 library not found for -lstdc++ 找不到问题](https://www.jianshu.com/p/6d94278d62b3)

```
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/usr/lib/
/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/lib/
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/lib/
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/usr/lib/
```



[关于解决 was built for newer iOS version (10.0) than being linked (8.0)问题](https://www.jianshu.com/p/43d8900c2673)

[【解决方法】ld: warning: directory not found for option](https://blog.csdn.net/zhyl8157121/article/details/48844573)



内存被过度释放
*** Incorrect guard value: 0
sip(724,0x16eacb000) malloc: *** set a breakpoint in malloc_error_break to debug
sip(724,0x1068eeb80) malloc: *** error for object 0x280dc2c10: pointer being freed was not allocated
sip(724,0x1068eeb80) malloc: *** set a breakpoint in malloc_error_break to debug
sip(724,0x16dbab000) malloc: Heap corruption detected, free list is damaged at 0x280dbfff0
*** Incorrect guard value: 0


### 参考：
[深入iOS系统底层之crash解决方法介绍](https://www.jianshu.com/p/cf0945f9c1f8)

