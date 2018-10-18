##  iOS常见报错信息



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

```
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/usr/lib/
/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/lib/
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/lib/
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/usr/lib/
```



