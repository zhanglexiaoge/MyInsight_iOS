##  iOS swift语法



### JSON到Model的映射
[TTReflect](https://github.com/TifaTsubasa/TTReflect)



### 闭包(Closures)


### Codable
Swift4.0

### Mirror
Swift的反射机制是基于一个叫 Mirror 的 struct 来实现的，其内部有如下属性和方法：
```
let children: Children   //对象的子节点。
displayStyle: Mirror.DisplayStyle?   //对象的展示风格
let subjectType: Any.Type   //对象的类型
func superclassMirror() -> Mirror?   //对象父类的 mirror
```


#### Swift 把 Struct 作为数据模型的注意事项
优点:
* 1.安全性：因为 Struct 是用值类型传递的，它们没有引用计数。
* 2.内存:由于他们没有引用数，他们不会因为循环引用导致内存泄漏。
* 3.速度:值类型通常来说是以栈的形式分配的，而不是用堆。因此他们比 Class 要快很多!  
* 4.拷贝:Objective-C 里拷贝一个对象,你必须选用正确的拷贝类型（深拷贝、浅拷贝）,而值类型的拷贝则非常轻松！
* 5.线程安全:值类型是自动线程安全的。无论你从哪个线程去访问你的 Struct ，都非常简单。

缺点:
* 1.Objective-C
当你的项目的代码是 Swift 和 Objective-C 混合开发时，你会发现在 Objective-C 的代码里无法调用 Swift 的 Struct。因为要在 Objective-C 里调用 Swift 代码的话，对象需要继承于 NSObject。
Struct 不是 Objective-C 的好朋友。
* 2.继承
Struct 不能相互继承。
* 3.NSUserDefaults
Struct 不能被序列化成 NSData 对象。
所以：如果模型较小，并且无需继承、无需储存到 NSUserDefault 或者无需 Objective-C 使用时，建议使用 Struct。
[Why Choose Struct Over Class?](http://stackoverflow.com/a/24243626/596821)



### 参考:
[王巍-swifter开发的100tips]
[iOS开发系列--Swift进阶](http://www.cnblogs.com/kenshincui/p/4824810.html)
[Swift 字典模型互转总结](https://www.cnblogs.com/duzhaoquan/p/6228525.html)

[Swift 浅谈Struct与Class](https://www.cnblogs.com/beckwang0912/p/8508299.html)

[Swift 数据转模型之Codable使用](https://blog.csdn.net/yingBi2014/article/details/80282622)
