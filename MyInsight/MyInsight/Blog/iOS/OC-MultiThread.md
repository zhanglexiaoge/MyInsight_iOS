##  OC-多线程(MultiThread)

###


### GCD


### NSTheard

<h3>多线程</h3>
<p>NSThread</p>
1、创建NSThread的两种方式
<br>
-(id) initWithTarget:(id) target selector:(SEL) selector object:(id) arg:
<br>
+(void)detachNewThreadSelector:(SEL) selector toTarget:(id) target withObject:(id) arg:
<br>
第二种方式，创建NSThread后会自动启动
<br>


2、NSThread的常用方法
<br>
+currentThread ： 返回当前正在执行的线程对象
<br>

<p>GCD</p>
GCD简化了多线程的实现，主要有两个核心概念：
<br>
1、队列：队列负责管理开发者提交的任务，以先进先出的方式来处理任务。
<br>
1）串行队列：每次只执行一个任务，当前一个任务执行完成后才执行下一个任务
<br>
2）并行队列：多个任务并发执行，所以先执行的任务可能最后才完成（因为具体的执行过程导致）
<br>
2、任务：任务就是开发者提供给队列的工作单元，这些任务将会提交给队列底层维护的线程池，因此这些任务将会以多线程的方式执行。
<p>NSOperation</p>
NSOperationQueue：代表一个先进先出的队列，负责管理系统提交的多个NSOperation。底层维护一个线程池，会按顺序启动线程来执行提交给队列的NSOperation
<br>
NSOperation：代表多线程任务。一般不直接使用NSOperation，而是使用NSOperation的子类。或者使用NSInvocationOperation和NSBlockOperation（这两个类继承自NSOperation）；
<br>
1、NSOperation的使用
<br>
NSOperation 的使用相较于GCD是面向对象的，OC实现的，而GCD应该是C实现的（看函数的定义和使用）。
<br>
使用NSOperation 只需两步：
<br>
1）创建 NSOperationQueue 队列，并未该队列设置相关属性
<br>
2）创建 NSOperation 子类对象，并将该对象提交给 NSOperationQueue 队列，该队列将会按顺序依次启动每个 NSOperation。
<br>



### 参考:
[在iOS中有几种方法来解决多线程访问同一个内存地址的互斥同步问题](https://blog.csdn.net/a_ellisa/article/details/51506233)
[iOS － 关于dispatch_sync(dispatch_get_main_queue(), ^{...;}); 死锁问题的解释](https://blog.csdn.net/icefishlily/article/details/52596802)
[GCD:嵌套dispatch_async时__block对象的一个内存陷阱](https://blog.csdn.net/fg313071405/article/details/25962939)
[ios-多线程访问共享资源](https://blog.csdn.net/ZCMUCZX/article/details/76974068)
[iOS开发多线程篇—线程安全](https://www.cnblogs.com/wendingding/p/3805841.html)

[iOS开发笔记之五十七——__weak与__strong是如何解决循环引用的](https://blog.csdn.net/lizitao/article/details/54845974)


