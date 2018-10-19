##  iOS代码块CodeSnippet

### 常见的代码块
1、属性

@property(nonatomic,strong) <#Class#> *<#object#>;

@property(nonatomic,assign) <#Class#> <#property#>;

@property(nonatomic,copy) NSString *<#name#>;

@property(nonatomic,weak)id<<#protocol#>> <#delegate#>;

@property(nonatomic,copy) <#Block#> <#block#>;

@property(nonatomic,copy) <#class#> (^<#block#>)(id<#object1#>,...);

2、类的创建

2.1  单例

static<#class#> *singleClass =nil;

+ (instancetype)shareInstance{

staticdispatch_once_t onceToken;

dispatch_once(&onceToken, ^{

<#code to be executed once#>

});

return<#expression#>

}
2.2  cell的创建

staticNSString *reuseID = <#property#>;

<#class#> *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];

if(!cell) {

cell = [[<#class#> alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];

}
2.3  tableView快捷创建

-(UITableView *)tableView {

if(!<#tableview#>) {

<#tableview#> = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];

<#tableview#>.delegate =self;

<#tableview#>.dataSource =self;

}

return<#tableview#>;

}

#pragma tableView--delegate

#pragma tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

return<#expression#>

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

return<#expression#>

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

staticNSString *identify =@"cellIdentify";

UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];

if(!cell) {

cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];

}

cell.textLabel.text =self.arrayTitle[indexPath.row];

returncell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

2.4  button的创建

UIButton *<#btn#> = [UIButton buttonWithType:UIButtonTypeCustom];

<#btn#>.frame = CGRectMake(100,100,100,50);

<#btn#>.backgroundColor = [UIColor orangeColor];

[<#btn#> addTarget:selfaction:@selector(<#btnClick#>:) forControlEvents:UIControlEventTouchUpInside];

[self.view addSubview:<#btn#>];


三、书签、注释类

#pragma mark - <#gmark#>

//TODO:<#info#>





### 参考：
[Xcode10 代码块(Code Snippet)添加和删除](https://blog.csdn.net/lg767201403/article/details/82761448?utm_source=blogxgwz1)
[Xcode10 添加代码块、查看icon图片](https://blog.csdn.net/zxtc19920/article/details/82783311?utm_source=blogxgwz0)
[iOS-- xcode10 自定义代码块的位置](https://blog.csdn.net/iotjin/article/details/49871085)
