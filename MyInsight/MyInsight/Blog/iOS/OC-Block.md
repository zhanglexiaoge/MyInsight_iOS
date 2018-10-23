## OC-BLOCK

### Block底层实现原理

前言　

　　要探索Block前先说一下我对Block的理解,我把它理解为：能够捕获它所在函数内部的变量的函数指针、匿名函数或者闭包。注意红色部份说的是它的精髓所在。希望看我这篇文章的人能够跟我说的步骤去做，做起来也比较简单，基本上是手把手，这样会有更好的效果，更深刻，当然如果只看文章就能够让读者明白，那是我更加希望的。
　　
　　一、首先，我们准备一个.m文件。我这里是main.m。内容如下:
　　
　　int main(int argc, char * argv[]) {
　　void (^test)() = ^(){
　　};
　　test();
　　}
　　接下来我要用到一个命令clang src.m -rewrite-objc -o dest.cpp.这个意思是用clang编译器对源文件src.m中的objective-c代码转换成C代码放在dest.cpp文件。其实xode编译时也会帮我们转换。我们这样就可以dest.cpp在看到我们定义和调用的block转换成C是怎么样的。执行命令后查看这个dest.cpp会发现有一大堆代码。下面我把对我们有用并能够说清楚原理的关键贴上来并加以注释：
　　
　　复制代码
　　//__block_imp：  这个是编译器给我们生成的结构体，每一个block都会用到这个结构体
　　struct __block_impl {
　　void *isa;　　　　　　　　　//对于本文可以忽略
　　int Flags;　　　　　　　　  //对于本文可以忽略
　　int Reserved;　　　　　　　//对于本文可以忽略　　　　　　　
　　void *FuncPtr;　　　　　　 //函数指针，这个会指向编译器给我们生成的下面的静态函数__main_block_func_0
　　};
　　
　　
　　/*__main_block_impl_0： 
　　是编译器给我们在main函数中定义的block
　　void (^test)() = ^(){
　　};
　　生成的对应的结构体
　　*/
　　struct __main_block_impl_0 {
　　struct __block_impl impl;  　　　　　　　　//__block_impl 变量impl
　　struct __main_block_desc_0* Desc;　　　　//__main_block_desc_0 指针，指向编译器给我们生成的结构体变量__main_block_desc_0_DATA __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {  //结构体的构造函数
　　impl.isa = &_NSConcreteStackBlock;  //说明block是栈blockimpl.Flags = flags;
　　impl.FuncPtr = fp;
　　Desc = desc;}};
　　//__main_block_func_0： 编译器根据block代码生成的全局态函数，会被赋值给impl.FuncPtr
　　static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
　　}
　　//__main_block_desc_0: 编译器根据block代码生成的block描述,主要是记录下__main_block_impl_0结构体大小
　　static struct __main_block_desc_0 {
　　size_t reserved;
　　size_t Block_size;
　　} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)}; //这里就生成了__main_block_desc_0的变量__main_block_desc_0_DATA
　　//这里就是main函数了
　　int main(int argc, char * argv[]) {
　　void (*test)() = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA)); //下面单独讲
　　((void (*)(__block_impl *))((__block_impl *)test)->FuncPtr)((__block_impl *)test);　                         //下面单独讲
　　}
　　复制代码
　　what the hell is that!!!! 没错，这也是我一开始看到这堆东西的感受。因为很多人讲Block原理都贴这个而且没有注释或很少注释，我也从网上搜出来看了几个。接下来就要说明白这堆代码。一定要有耐心，首先，对着上面代码注释过几遍main函数前系统给我们生成的这些结构体函数之间的关系，如果一次能明白自然是好，过了几遍都没明白也没关系，但如果不明一定回头要再理清。
　　
　　回归一开始我对block的理解，先忽略它能够捕获所在函数内部的变量，那么它就是一个函数指。
　　
　　void (^test)() = ^(){
　　};
　　就对应着
　　void (*test)() = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));
　　这个总的来说就是定义一个函数指针指向一个地址，但是这个地址并不是我样平常的函数的入口地址
　　　转换后代码的要一段段从后往前组合分析：
　　　
　　　复制代码
　　　__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA))就是创建了一个__main_block_impl_0结构体的一个实例
　　　
　　　&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA))取这个实例的地址
　　　
　　　((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA))把实例地址强转为一个函数地址
　　　
　　　void (*test)() = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));
　　　那么这整句就是说定义一个函数指针指向一个新创建的__main_block_impl_0实例的地址。注意创建这个实例时构选函数传的两个参数，
　　　正是编译器帮我们生成的静态函数__main_block_func_0及__main_block_desc_0的变量__main_block_desc_0_DATA
　　　复制代码
　　　复制代码
　　　test();
　　　对应着
　　　((void (*)(__block_impl *))((__block_impl *)test)->FuncPtr)((__block_impl *)test);
　　　总的来说意思就是通过函数指针test调用函数FnucPtr,传的参数为指针test本身。
　　　
　　　虽然能够理解这句的意思，但这里有点隐晦，还是要进行说明一下
　　　1、调用时不是应该这样调才对吗  test(test它指向__main_block_impl_0)->impl.FuncPtr,其实它跟((__block_impl *)test)->FuncPtr)是同等作用。
　　　2、FuncPtr（即__main_block_func_0）的参数类型不是__main_block_impl_0 *，为什么clang编译出来后是__block_impl*。其实这里不管类型是什么，它还是传了test作为参数进去，所是不会有错的。
　　　
　　　复制代码
　　　好了讲到这里，就可以进行一个中途简单性的总结：忽略中间的复杂分支，留下主线，当我们声明一个block变量a并为它赋值时，其实就是创建一个函数指针ptrA,再根据block a赋值的代码生成一个静态函数，而指针ptrA就指向这个静态函数。block a调用时就是使用函数指ptrA调用生成的静态函数。
　　　
　　　讲到这里第一部分就结束了，接下来进行第二部分。
　　　
　　　
　　　
　　　　　二、这部分就要开始讲精髓的部分，捕获它所在函数内部的变量，接下来的部分都不会像第一部分那样写那么详细的注释，只会在关键和不一样的地方加上注释。并且通过观看不同变化，从实践中得出结论并明白它实现原理。即然要说捕获它所在函数内部的变量，那么接下来我们就把main.m修改一下，加个变量（基本类型变量）呗。代码变成这样：
　　　　　
　　　　　复制代码
　　　　　int main(int argc, char * argv[]) {
　　　　　int value = 1;
　　　　　void (^test)() = ^(){
　　　　　int valueTest = value;
　　　　　};
　　　　　test();
　　　　　}
　　　　　复制代码
　　　　　　　那么经过clang转换之后会变成这样, 与第一部份不一样的地方我会把它变成粗体，仔细对比第一部分并思考，应该不难理解。
　　　　　　　
　　　　　　　复制代码
　　　　　　　struct __block_impl {
　　　　　　　void *isa;
　　　　　　　int Flags;
　　　　　　　int Reserved;
　　　　　　　void *FuncPtr;
　　　　　　　};
　　　　　　　
　　　　　　　struct __main_block_impl_0 {
　　　　　　　struct __block_impl impl;
　　　　　　　struct __main_block_desc_0* Desc;
　　　　　　　int value;
　　　　　　　__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _value, int flags=0) : value(_value) {
　　　　　　　impl.isa = &_NSConcreteStackBlock;
　　　　　　　impl.Flags = flags;
　　　　　　　impl.FuncPtr = fp;
　　　　　　　Desc = desc;
　　　　　　　}
　　　　　　　};
　　　　　　　
　　　　　　　static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
　　　　　　　int value = __cself->value; // bound by copy
　　　　　　　int valueTest = value;
　　　　　　　}
　　　　　　　
　　　　　　　static struct __main_block_desc_0 {
　　　　　　　size_t reserved;
　　　　　　　size_t Block_size;
　　　　　　　} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
　　　　　　　int main(int argc, char * argv[]) {
　　　　　　　int value = 1;
　　　　　　　void (*test)() = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, value));
　　　　　　　((void (*)(__block_impl *))((__block_impl *)test)->FuncPtr)((__block_impl *)test);
　　　　　　　}
　　　　　　　复制代码
　　　　　　　　　首先我们可以看到的变化点有：1、__main_block_impl_0结构体中多了个value，其实它就是用来保存main函数中的value，还有它的构造函数多了一个参数2、__main_block_func_0这个函数的实现会新增一个变量value并被赋值。
　　　　　　　　　
　　　　　　　　　从对比中我们可以知道，变量其实是在构造__main_block_impl_0实例时传进去了并被保存，当回调时通过把test（其实就是指向一个__main_block_impl_0实例）作为参数传进来，通过它拿到了变量。这样就实现了捕获局部变量。当block要捕获多个变量时会是怎么的呢？其实不难猜，有N个变量要被捕__main_block_impl_0结构体中就会有N个变量用于保存，它的构造函数就会有N个参数是用来传这N个变量进来保存。回调时通过test（指向__main_block_impl_0实例）一一拿到。这里就不贴代码了，有兴趣可以自己验证一下。
　　　　　　　　　
　　　　　　　　　　　　原来捕获函数内部变量其实就是这样实现的呀。有了上面的基础，你是否会想那么__block修饰的变量是怎么样的？变量是个NSObject对象是怎么样的？
　　　　　　　　　　　　
　　　　　　　　　　　　回调传参又是怎么样的？还有人们经常说的对self的引用什么的会是怎么样？接下来就进入第三部分。有了前面两部份的基础，后面的基本就是看代码得结论，会少很多文字说明了。所以前面两部份一定要理解好。
　　　　　　　　　　　　
　　　　　　　　　　　　三、 在写这部份前想着，不就像前面一样用clang一下，对比一下代码就可以知道了吗。先来简单一点的。
　　　　　　　　　　　　
　　　　　　　　　　　　(1)带有参数和返回值的block.
　　　　　　　　　　　　
　　　　　　　　　　　　把main.m改成这样
　　　　　　　　　　　　
　　　　　　　　　　　　int main(int argc, char * argv[]) {
　　　　　　　　　　　　int (^test)(int a) = ^(int a){
　　　　　　　　　　　　return a;
　　　　　　　　　　　　};
　　　　　　　　　　　　test(1);
　　　　　　　　　　　　}
　　　　　　　　　　　　　　接着它转换后的：
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　复制代码
　　　　　　　　　　　　　　struct __main_block_impl_0 {
　　　　　　　　　　　　　　struct __block_impl impl;
　　　　　　　　　　　　　　struct __main_block_desc_0* Desc;
　　　　　　　　　　　　　　__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
　　　　　　　　　　　　　　impl.isa = &_NSConcreteStackBlock;
　　　　　　　　　　　　　　impl.Flags = flags;
　　　　　　　　　　　　　　impl.FuncPtr = fp;
　　　　　　　　　　　　　　Desc = desc;
　　　　　　　　　　　　　　}
　　　　　　　　　　　　　　};
　　　　　　　　　　　　　　static int __main_block_func_0(struct __main_block_impl_0 *__cself, int a) {
　　　　　　　　　　　　　　return a;
　　　　　　　　　　　　　　}
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　static struct __main_block_desc_0 {
　　　　　　　　　　　　　　size_t reserved;
　　　　　　　　　　　　　　size_t Block_size;
　　　　　　　　　　　　　　} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
　　　　　　　　　　　　　　int main(int argc, char * argv[]) {
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　int (*test)(int a) = ((int (*)(int))&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));
　　　　　　　　　　　　　　((int (*)(__block_impl *, int))((__block_impl *)test)->FuncPtr)((__block_impl *)test, 1);
　　　　　　　　　　　　　　}
　　　　　　　　　　　　　　复制代码
　　　　　　　　　　　　　　这里应该没什么难度，不难理解，就是__main_block_func_0函数多了个参数和返回值，就不细说了。
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　(2)加上了__block修饰符的基本变量时：
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　把main.m代码改成这样：
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　复制代码
　　　　　　　　　　　　　　int main(int argc, char * argv[]) {
　　　　　　　　　　　　　　__block int value = 1;
　　　　　　　　　　　　　　void (^test)() = ^(){
　　　　　　　　　　　　　　value = 2;
　　　　　　　　　　　　　　};
　　　　　　　　　　　　　　test();
　　　　　　　　　　　　　　int value1 = value;
　　　　　　　　　　　　　　}
　　　　　　　　　　　　　　复制代码
　　　　　　　　　　　　　　转换后就变成：（接下来会稍微有点复杂，不要紧，只要耐心点也是可以明白的）
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　复制代码
　　　　　　　　　　　　　　//这个是导出的一些接口，用于管理__block变量value内存的一些接口
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　extern "C" __declspec(dllexport) void _Block_object_assign(void *, const void *, const int);
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　extern "C" __declspec(dllexport) void _Block_object_dispose(const void *, const int);
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　//根据带__block修饰符的变量value，编译器给我们生成了个结构体
　　　　　　　　　　　　　　struct __Block_byref_value_0 {
　　　　　　　　　　　　　　void *__isa;
　　　　　　　　　　　　　　__Block_byref_value_0 *__forwarding;   //这个会指向被创建出来的__Block_byref_value_0实例
　　　　　　　　　　　　　　int __flags;
　　　　　　　　　　　　　　int __size;
　　　　　　　　　　　　　　int value;
　　　　　　　　　　　　　　};
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　struct __main_block_impl_0 {
　　　　　　　　　　　　　　struct __block_impl impl;
　　　　　　　　　　　　　　struct __main_block_desc_0* Desc;
　　　　　　　　　　　　　　__Block_byref_value_0 *value;  //保存__Block_byref_value_0变量
　　　　　　　　　　　　　　__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_value_0 *_value, int flags=0) : value(_value->__forwarding) {
　　　　　　　　　　　　　　impl.isa = &_NSConcreteStackBlock;
　　　　　　　　　　　　　　impl.Flags = flags;
　　　　　　　　　　　　　　impl.FuncPtr = fp;
　　　　　　　　　　　　　　Desc = desc;
　　　　　　　　　　　　　　}
　　　　　　　　　　　　　　};
　　　　　　　　　　　　　　static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
　　　　　　　　　　　　　　__Block_byref_value_0 *value = __cself->value; // bound by ref
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　(value->__forwarding->value) = 2;
　　　　　　　　　　　　　　}
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　//这两个函数分别会在test block 被拷贝到堆和释构时调用的，作用是对__Block_byref_value_0实例的内存进行管理，至于怎么管理，这里就不讨论了，这里就会调用上面导出来的接口。
　　　　　　　　　　　　　　static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->value, (void*)src->value, 8/*BLOCK_FIELD_IS_BYREF*/);}
　　　　　　　　　　　　　　static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->value, 8/*BLOCK_FIELD_IS_BYREF*/);}
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　static struct __main_block_desc_0 {
　　　　　　　　　　　　　　size_t reserved;
　　　　　　　　　　　　　　size_t Block_size;
　　　　　　　　　　　　　　void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*); //回调函数指针，会被赋值为__main_block_copy_0
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　void (*dispose)(struct __main_block_impl_0*);　　　　　　　　　　　　//回调函数指针，会被赋值为__main_block_dispose_0
　　　　　　　　　　　　　　} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0}; /*{ 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0}，这句就是创建一个例的意思，这是结构体的一种构造方式。*/
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　int main(int argc, char * argv[]) {
　　　　　　　　　　　　　　/*我们定义的__block int value转换后并不是一个简单的栈变量，而会是新建的__Block_byref_value_0堆变量*/
　　　　　　　　　　　　　　__attribute__((__blocks__(byref))) __Block_byref_value_0 value = {(void*)0,(__Block_byref_value_0 *)&value, 0, sizeof(__Block_byref_value_0), 1};
　　　　　　　　　　　　　　
　　　　　　　　　　　　　　void (*test)() = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, (__Block_byref_value_0 *)&value, 570425344));
　　　　　　　　　　　　　　((void (*)(__block_impl *))((__block_impl *)test)->FuncPtr)((__block_impl *)test);
　　　　　　　　　　　　　　　　//最后面使这句int value1 = value;使用value时，在我们表面看到是好像是使用main函数里的一个局部栈变量，其实不是，使用的是堆里面的容int value1 = (value.__forwarding->value);
　　　　　　　　　　　　　　　　}
　　　　　　　　　　　　　　　　复制代码
　　　　　　　　　　　　　　　　
　　　　　　　　　　　　　　　　
　　　　　　　　　　　　　　　　从代码里的注释再加上前面两部份这讲解，应该是可以看明白这段代码的。简单做个说明：一开始我会猜想__block修饰的变量的值能在block代码块中被修改，不就是在第二部分中的传一个变量值变成传这个变量的地址进去吗？其实这样是有问题的，要明白如果这样，就是相当是传了一个栈变量的地址进去，函数结束这个地址就不可用了，编译器才会给我们创建一个新的结构__Block_byref_value_0
　　　　　　　　　　　　　　　　
　　　　　　　　　　　　　　　　
　　　　　　　　　　　　　　　　
　　　　　　　　　　　　　　　　小结：
　　　　　　　　　　　　　　　　
　　　　　　　　　　　　　　　　本文是我在学习block的过程中，通过看别人文章，源码并自己亲自己动手实践得出来的结果，宗旨是让大家更容易明白block的底层实现原理。
　　　　　　　　　　　　　　　　
　　　　　　　　　　　　　　　　如果想了解本文以外block的知识或者更深入了解，参考:biosli、tripleCC、llvm.org、clang对block的编译规则，这里就不展开了，有时间再写。



#### 参考
[探索 Block (一) (手把手讲解Block 底层实现原理)](https://www.cnblogs.com/chenxianming/p/5554395.html)

[如何在 block 中修改外部变量](https://blog.csdn.net/a_ellisa/article/details/51523646)

[理解__unsafe_unretained](https://blog.csdn.net/junjun150013652/article/details/53148711)

[有一种 Block 叫 Callback，有一种 Callback 叫 CompletionHandler](https://www.jianshu.com/p/061c393d6c9d)

[到底什么时候才需要在ObjC的Block中使用weakSelf/strongSelf](http://blog.lessfun.com/blog/2014/11/22/when-should-use-weakself-and-strongself-in-objc-block/)

[正确使用Block避免Cycle Retain和Crash](http://tanqisen.github.io/blog/2013/04/19/gcd-block-cycle-retain/)

[iOS Block用法和实现原理](https://www.jianshu.com/p/d28a5633b963)

[iOS中Block的用法，举例，解析与底层原理（这可能是最详细的Block解析）](https://www.jianshu.com/p/bcd494ba0e22)

[Block的内存管理，看这里就够了](https://www.jianshu.com/p/4a6dca34d980)
