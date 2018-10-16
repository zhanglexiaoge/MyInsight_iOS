//
//  OpenGLVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/3/21.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "OpenGLVC.h"

/*
 iOS OpenGL ES菜鸟学习笔记（1）——画一个简单的三角形
 https://www.jianshu.com/p/4acd19358b69
 */


@interface OpenGLVC ()
{
    GLuint vertexBufferId;
}
@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@end

// 这个数据类型用于存储每一个顶点数据
typedef struct {
    GLKVector3 positionCoords;
} SceneVertex;

// 创建本例中要用到的三角形顶点数据
const SceneVertex vertices []  =
{
    {{-0.5, -0.5, 0.0}},  // 左下
    {{ 0.5, -0.5, 0.0}},  // 右下
    {{-0.5,  0.5, 0.0}}  // 左上
};

@implementation OpenGLVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"OpenGL";
    
    GLKView *view = (GLKView *)self.view;
    //NSAssert([view isKindOfClass:[GLKView class]], @"ViewController's view is not a GLKView");
    
    // 创建一个OpenGL ES 2.0 context（上下文）并将其提供给view
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // 将刚刚创建的context设置为当前context
    [EAGLContext setCurrentContext:view.context];
    
    // 创建一个提供标准OpenGL ES 2.0的GLKBaseEffect
    self.baseEffect = [[GLKBaseEffect alloc] init];
    // 启用Shading Language programs（着色语言程序）
    self.baseEffect.useConstantColor = GL_TRUE;
    // 设置渲染图形用的颜色为白色
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    
    // 设置当前context的背景色为黑色
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    
    /*
     * glGenBuffers(GLsizei n, GLuint *buffers);
     * 生成缓存，指定缓存数量，并保存在vertexBufferId中
     * 第一个参数：指定要生成的缓存标识符的数量
     * 第二个参数：指针，指向生成的标识符的内存位置（熟悉C和C++的小伙伴应该不陌生了）
     */
    glGenBuffers(1, &vertexBufferId);
    
    /*
     * glBindBuffer(GLenum target, GLuint buffer);
     * 绑定由于指定标识符的缓存到当前缓存
     * 第一个参数：用于指定要绑定哪一类型的内存(GL_ARRAY_BUFFER | GL_ELEMENT_ARRAY_BUFFER)，GL_ARRAY_BUFFER用于指定一个顶点属性数组
     * 第二个参数：要绑定魂缓存的标识符
     */
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferId);
    
    /*
     * glBufferData(GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage);
     * 复制应用的顶点数据到context所绑定的顶点缓存中
     * 第一个参数：指定要更新当前context中所绑定的是哪一类型的缓存
     * 第二个参数：指定要复制进缓存的字节的数量
     * 第三个参数：要复制的字节的地址
     * 第四个参数：提示缓存在未来的运算中将被怎样使用(GL_STATIC_DRAW | GL_DYNAMIC_DRAW)，GL_STATIC_DRAW是指缓存中的内容可以复制到GPU的内存中，因为很少对其进行更改。
     */
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // 告诉baseEffect准备好当前OpenGL ES的context，马上就要绘画了
    [self.baseEffect prepareToDraw];
    
    // 清除当前绑定的帧缓存的像素颜色渲染缓存中的每一个像素的颜色为前面使用glClearColor函数设置的值
    glClear(GL_COLOR_BUFFER_BIT);
    
    /*
     * glEnableVertexAttribArray(GLuint index)
     * 启动某项缓存的渲染操作（GLKVertexAttribPosition | GLKVertexAttribNormal | GLKVertexAttribTexCoord0 | GLKVertexAttribTexCoord1）
     * GLKVertexAttribPosition 用于顶点数据
     * GLKVertexAttribNormal 用于法线
     * GLKVertexAttribTexCoord0 与 GLKVertexAttribTexCoord1 均为纹理
     */
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    /*
     * glVertexAttribPointer(GLuint indx, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid *ptr);
     * 渲染相应数据（此处绘制顶点数据）
     * 第一个参数：当前要绘制的值什么类型的数据，与glEnableVertexAttribArray()相同
     * 第二个参数：每个位置有3个部分
     * 第三个参数：每个部分都保存为一个float值
     * 第四个参数：告诉OpenGL ES小数点固定数据是否可以被改变
     * 第五个参数：“步幅”，即从一个顶点的内存开始位置转到下一个顶点的内存开始位置需要跳过多少字节
     * 第六个参数：告诉OpenGL ES从当前的绑定的顶点缓存的开始位置访问顶点数据
     */
    glVertexAttribPointer(GLKVertexAttribPosition,  // 当前绘制顶点数据
                          3,    // 每个顶点3个值
                          GL_FLOAT, // 数据为float
                          GL_FALSE, // 不需要做任何转化
                          sizeof(SceneVertex),  // 每个顶点之间的内存间隔为sizeof(SceneVertex)
                          NULL); // 偏移量为0，从开始绘制，也可以传0
    
    
    /*
     * glDrawArrays(GLenum mode, GLint first, GLsizei count)
     * 执行绘图操作
     * 第一个参数：告诉GPU如何处理绑定的顶点缓存内的数据
     * 第二个参数：指定缓存内需要渲染的第一个数据（此处为顶点）的位置，0即为从开始绘制
     * 第三个参数：指定缓存内需要渲染的数据（此处为顶点）的数量
     */
    glDrawArrays(GL_TRIANGLES,  // 绘制三角形
                 0, // 从开始绘制
                 3);    // 共3个顶点
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
