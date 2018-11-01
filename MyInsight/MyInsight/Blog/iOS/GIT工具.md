##  Git工具


### Git常用命令
`git config`

`git branch`：用于列出，创建或删除分支

`git merge`：

* 查看用户名以及邮箱，使用git config命令
`git config user.name
git config user.email
`
* 修改用户名以及邮箱，使用git config 命令的--global参数
`git config --global user.name "your name"
git config --global user.email "your email"
`

* 终端输入下面内容，再git pull一次，输入一次用户名密码就会自动保存该用户名密码
`git config --global credential.helper store`

* 清除掉缓存在git中的用户名和密码
`git config --global credential.helper wincred`

* 清除掉缓存在git中的用户名和密码
`git credential-manager uninstall`

* git清除用户名密码
`git config --system --unset credential.helper`

* 查看配置的用户信息
`git config --list`




### 参考
[Git教程](https://www.yiibai.com/git/)

[Git Pro](http://iissnan.com/progit/)
