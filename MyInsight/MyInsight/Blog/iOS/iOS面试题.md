### 面试题





主要问最近的工作内容，工作中遇到的困难什么







阿里巴巴电话面试

问的比较基础

属性

block

网络请求

runtime机制 

Runloop 与多线程

映射

SDImage源码



游禧科技 7477网页游戏







面向切面编程

定时器用的Runloop那种状态







招银

自动释放池机制

autolayout 及iOS9后新出的布局







1.说下线程和进程的区别

（1）一个线程只能属于一个进程，而一个进程可以有多个线程，但至少有一个线程。线程是操作系统可识别的最小执行和调度单位。

（2）资源分配给进程，同一进程的所有线程共享该进程的所有资源。 同一进程中的多个线程共享代码段(代码和常量)，数据段(全局变量和静态变量)，扩展段(堆存储)。但是每个线程拥有自己的栈段，栈段又叫运行时段，用来存放所有局部变量和临时变量。

（3）处理机分给线程，即真正在处理机上运行的是线程。

（4）线程在执行过程中，需要协作同步。不同进程的线程间要利用消息通信的办法实现同步。 

2.如何保证线程安全

一块资源可能会被多个线程共享，也就是多个线程可能会访问同一块资源，比如多个线程访问同一个对象、同一个变量、同一个文件。当多个线程访问同一块资源时，很容易引发数据错乱和数据安全问题。此时，我们需要用线程锁来解决。

（1）nonatomic atomic：使用atomic多线程原子性控制，atomic的原理给setter加上锁，                             getter不会加锁。OC在定义属性时有nonatomic和atomic两种选择

atomic：原子属性，为setter方法加锁（默认就是atomic）

nonatomic：非原子属性，不会为setter方法加锁

(2)使用GCD实现atomic操作：给某字段的setter和getter方法加上同步队列:

```c
 -(void)setCount:(NSInteger)newcount {

    dispatch_sync(_synQueue, ^{ count = newcount; });

}

- (NSInteger)count {

   __block NSInteger localCount;

   dispatch_sync(_synQueue, ^{

        localCount = count;

   });

   return localCount;

}

```

3、 使用NSLock

```c
- (void)threadRunLock {
       _lock = [[NSLock alloc]init];

       while (true) {
            [_lock lock];

            if (self.number > 0) {

               [NSThread sleepForTimeInterval:0.5];

               self.number --;

               NSLog(@"thread:%@ ---> %ld",[[NSThread currentThread] name],self.number);
           }
           [_lock unlock];
       }
 }

```

 相当于给代码片段加上lock了，所以依次输出9-0

4、使用互斥锁

使用格式

@synchronized(锁对象) { // 需要锁定的代码  }

注意：锁定1份代码只用1把锁，用多把锁是无效的

```c
-(void)sellTickets {
    while (true) {
        @synchronized(self) {
            //只能加一把锁
            //1.先检查票数
            int count=self.leftTicketsCount;
            if (count>0) {
                //暂停一段时间
                [NSThread sleepForTimeInterval:0.002];
                //2.票数-1
                self.leftTicketsCount= count-1;
                //获取当前线程
                NSThread *current=[NSThread currentThread];
                NSLog(@"%@--卖了一张票，还剩余%d张票",current,self.leftTicketsCount);
             } else {
               //退出线程
               [NSThread exit];
            }
        }
    }
 }
```

互斥锁的优缺点：

优点：能有效防止因多线程抢夺资源造成的数据安全问题

缺点：需要消耗大量的CPU资源

3、了解哪些设计模式

  （1）代理模式

  （2）观察者模式

  （3）MVC模式

  （4）单例模式

4、堆和栈的区别，工程项目中的哪些数据是储存在堆哪些在栈中



在引入堆和栈之前，先要知道，iOS中的内存管理范围：

​    oc对象需要进行内存管理，非oc对象不需要进行内存管理，比如基本数据类型

所以：



OC对象存放于堆里面(堆内存要程序员手动回收)

非OC对象一般放在栈里面(栈内存会被系统自动回收)

堆里面的内存是动态分配的，所以也就需要程序员手动的去添加内存、回收内存

堆和栈的区别：



栈是吃了吐 LIFO(先进后出)

堆是吃了拉 FIFO(先进先出)

5、iOS中的NSCopying协议，copy,MutableCopy的区别

首先我们先说两个两个概念：



浅复制：不拷贝对象本身，仅仅是拷贝指向对象的指针

深复制：是直接拷贝整个对象内存到另一块内存中

然后我们再来看copy关键字的特点：



修改源对象的属性和行为，不会影响副本对象

修改副本对象的属性和行为，不会影响源对象

一个对象可以通过copy和mutableCopy方法来创建一个副本对象

copy:创建的是不可变副本（NSString，NSArray，NSDictionary）

mutableCopy：创建的是可变副本（NSMutableString，NSMutableArray，NSMutableDictionary）

6、解释属性修饰关键词的作用（weak,strong,copy,readOnly,assgin,nonatomic等）



1.assgin

此标记说明设置器直接进行赋值，这也是默认值且setter方法直接将传入参数赋值给实例变量，不涉及引用计数的变化，也没有引用技术可以供管理；

主要用于非指针变量(也可以修饰指针变量，但是平时都不这么用)，即用于基础数据类型(例如NSInteger)和C的数据类型(int, float, double, char)另外还有id类型的属性，总而言之，前面不需要加"*"的就可以用assign修饰；

2.retian ：

表示持有特性，一般用于指针对象，例如数组（NSMutableArray，NSArray），字典对象，视图对象（UIView ），控制器对象（UIViewController）等，这些属性需要保存引用计数；

就是说你定义了一个变量，然后这个变量在程序的运行过程中会被更改，并且影响到其他方法，当用retain时，会释放旧的对象，将输入对象的索引计数+1，然后将输入对象的值赋予新对象。

3.copy ：

其setter方法是进行Copy操作，与retain处理流程基本一样，先旧对象release，再Copy出新的对象，retainCount为1，这是为了减少对上下文的依赖而引入的机制，区别在于copy主要用于NSString；retain是指针拷贝，copy是内容拷贝然后新的对象开辟新内存，引用计数为1，原来对象计数不变

4.weak：

weak是弱引用，是由ARC引入的对象变量的属性，相当于assign，只有在你打开ARC时才会被要求使用(但是weak只能修饰对象即指针类型的属性和id类型的属性，所以在ARC中修饰基本数据类型的属性还是要用assign)；

weak比assign多了一个功能，就是对象消失后把指针置为nil，避免了野指针，不是null指针，是指向“垃圾”内存（不可用的内存）的指针；

5.strong：

strong是强引用，是ARC新引入的对象变量属性，简单讲strong等同retain，只有在你打开ARC时才会被要求使用；

但是对于strong来说，它会自己判断是选择retain还是copy，比较方便。

6.readonly：

此标记说明属性是只读的，默认的标记是读写，如果你指定了只读，在@implementation中只需要一个读取器，如果你使用@synthesize关键字，也只有读取器方法被解析，即只会生成getter方法，不会生成setter方法；

不希望属性在类外改变时候使用。

7.readwrite：

此标记说明属性会被当成读写的，这也是默认属性。设置器和读取器都需要在@implementation中实现。如果使用@synthesize关键字，读取器和设置器都会被解析，即会同时生成getter和setter方法；

8.nonatomic：

非原子性访问，对属性赋值的时候不加锁，不加同步，多线程并发访问会提高性能。如果不加此属性，则默认是两个访问方法都为原子型事务访问；

非原子操作，会简单的操作属性的值，这会加快属性存取的速度，但没办法保证在多线程环境下不出错。

9.atomc:

原子操作，这是默认的，在多线程环境下，本方法设定为原子操作提供了可靠的属性存取方法，而不用担心并发时会产生问题；

这也就是说，在多线程环境下，解析的访问器提供一个对属性的安全访问，从获取器得到的返回值或者通过设置器设置的值可以一次完成，即便是别的线程也正在对其进行访问。









