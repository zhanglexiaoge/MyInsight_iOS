##  一些指令


### [HomeBrew](https://brew.sh)
安装
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
卸载
```
cd `brew --prefix`
rm -rf Cellar
brew prune
rm `git ls-files`
rm -r Library/Homebrew Library/Aliases Library/Formula Library/Contributions
rm -rf .git
rm -rf ~/Library/Caches/Homebrew
```

使用
1. 安装任意包
```
brew install <packageName>
```
卸载任意包
```
brew uninstall <packageName>
```
查询可用包
```
brew search <packageName>
```
查看已安装包列表
```
brew list
```
查看任意包信息
```
brew info <packageName>
```
更新HomeBrew
```
brew update
```
查看Homebrew版本
```
brew -v
```
Homebrew帮助信息
```
brew -h
```

### nmp包管理








Xcode工程清除缓存路径
```
~/Library/Developer/Xcode/DerivedData/
```

### 参考:
[Homebrew介绍和使用](https://www.jianshu.com/p/de6f1d2d37bf)

