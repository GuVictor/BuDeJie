//
//  ViewController.m
//  网易新闻
//
//  Created by 古伟东 on 2017/3/16.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "ViewController.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *titleScrollView;
@property (weak, nonatomic) UIScrollView *contentScrollView;

@property (weak, nonatomic) UIButton *selectButton;

@property (strong, nonatomic) NSMutableArray<UIButton *> *titleButtons;

@property (assign, nonatomic) BOOL  isInitialize;

@end

@implementation ViewController

#pragma mark - 懒加载
//装按钮的数组
- (NSMutableArray<UIButton *> *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    
    return _titleButtons;
}

#pragma mark - View的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条标题
//    self.title = @"网易新闻";

    
    //1.添加标题滚动视图
    [self setupTitleScrollView];
    //2.添加内容滚动视图
    [self setupContentScrollVIew];
   
  
    
    //ios7后导航控制器中的scrollview顶部默认会条件64的额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //处理标题点击
}

#pragma mark - 因为这个方法添加很多次, 所有只有设置一次就行
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isInitialize == NO) {
        //4.设置所有子标题
        [self setupAllTitle];
        
        _isInitialize = YES;
    }
}




#pragma mark - 设置所有子标题
- (void)setupAllTitle {
    //已经把内容展示上去 -》展示的效果是否是我们想要的调整细节
    //1.标题颜色为黑色
    //2.需要让titleScrollview可以滚动
    
    //添加所有按钮标题
    NSInteger count = self.childViewControllers.count;
    
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonW = 100;
    CGFloat buttonH = self.titleScrollView.bounds.size.height;
    
    for (int i= 0; i<count; i++) {
        
        buttonX = buttonW * i;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        //给每个控制器绑定一个按钮
        btn.tag = i;
        UIViewController *vc = self.childViewControllers[i];
        //设置按钮标题
        [btn setTitle:vc.title forState:UIControlStateNormal];
        //设置标题颜色
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //监听按钮点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleButtons addObject:btn];
        
        if (i == 0) {
            [self btnClick:btn];
        }
        
        //把按钮一个个添加上去
        [self.titleScrollView addSubview:btn];
    }
    
    //设置滚动范围
    self.titleScrollView.contentSize = CGSizeMake(count * buttonW, 0);
    //隐藏滚动条
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    //设置内容滚动范围
    self.contentScrollView.contentSize = CGSizeMake(screenW * count, 0);
    
    
}
#pragma mark - 选中标题按钮处理
- (void)selBtn:(UIButton *)btn {
   
    //1.把上次记录的按钮标题颜色改为黑色
    [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectButton.transform = CGAffineTransformIdentity;
    
    //2.把当前点击按钮标题设置成红色
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    //让按钮居中
    [self setupTitleCenter:btn];
    
    //字体缩放:形变
    btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    //3.记录当前选中按钮
    self.selectButton = btn;
    
    
    }

#pragma mark - 标题居中
- (void)setupTitleCenter:(UIButton *)button {
    
    //让标题居中显示
    CGFloat offsetx = button.center.x - screenW * 0.5;
    
    if (offsetx < 0) {
        offsetx = 0;
    }

//    self.titleScrollView.contentOffset = CGPointMake(offsetx, 0);
    
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - screenW;
    
    if (offsetx > maxOffsetX) {
        offsetx = maxOffsetX;
    }
    
    
    [self.titleScrollView setContentOffset: CGPointMake(offsetx, 0) animated:YES];

    
    }

#pragma mark - 处理按钮点击
- (void)btnClick:(UIButton *)button {
    //1.标题颜色变成红色
    [self selBtn:button];
    
    //2把对应的控制器view添加上去
    NSInteger i = button.tag;
    [self setupOneViewController:i];

    //3.内容滚动视图滚动到对应的位置
    CGFloat x = i * screenW;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
    
    
}

#pragma mark - 添加控制器对应的view
- (void)setupOneViewController:(NSInteger)i {
    //2把对应的控制器view添加上去
    
    UIViewController *Vc = self.childViewControllers[i];
    if (Vc.view.superview  ) {
        return ;
    }
    
    UIViewController *vc = self.childViewControllers[i];
    
    CGFloat x = i * screenW;
    vc.view.frame = CGRectMake(x, 0, screenW, self.contentScrollView.bounds.size.height);
    
    //从后面追加一个view
    [self.contentScrollView addSubview:vc.view];
}

#pragma mark - 添加标题滚动视图

- (void)setupTitleScrollView {
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
    CGFloat titleScrollViewX = 0;
    CGFloat titleScrollViewY = self.navigationController.navigationBarHidden ? 20 : 64;
    CGFloat titleScrollViewW = screenW;
    CGFloat titleScrollViewH = 30;
    
    //设置frame
    titleScrollView.frame = CGRectMake(titleScrollViewX, titleScrollViewY, titleScrollViewW, titleScrollViewH);
    
    //设置颜色
//    titleScrollView.backgroundColor = GWDColor(220, 220, 221);
//    titleScrollView.backgroundColor = [UIColor whiteColor];
//    titleScrollView.alpha = 0.5;
    titleScrollView.backgroundColor = [UIColor colorWithRed:220/256.0 green:220/256.0 blue:221/256.0 alpha:1];
    
    //添加标题滚动视图
    [self.view addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
}




#pragma mark - 添加内容滚动视图
- (void)setupContentScrollVIew {
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    CGFloat contentScrollViewX = 0;
    CGFloat contentScrollViewY = CGRectGetMaxY(self.titleScrollView.frame);
    CGFloat contentScrollViewW = screenW;
    CGFloat contentScrollViewH = screenH - contentScrollViewY;
    
    //设置frame
    contentScrollView.frame = CGRectMake(contentScrollViewX  , contentScrollViewY, contentScrollViewW , contentScrollViewH);
    
    //设置颜色
//    contentScrollView.backgroundColor = [UIColor blueColor];
    
    //添加滚动视图的当前的view
    [self.view addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
    
    //设置contentScrollView的属性
    //分页
    contentScrollView.pagingEnabled = YES;
    //弹簧
    contentScrollView.bounces = NO;
    //水平滚动条，指示器
    contentScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentScrollView.delegate = self;
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //1.选中标题
    //获取按钮角标
    NSInteger i = scrollView.contentOffset.x / screenW;
    //取出按钮
    UIButton *btn = self.titleButtons[i];
    //设置选中按钮
    [self selBtn:btn];
    
    //2.把对应子控制器的view添加上去
    [self setupOneViewController:i];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //字体缩放  1.缩放比例  2.缩放按钮
    NSInteger i = scrollView.contentOffset.x / screenW;
//    NSLog(@"%ld", i);
    NSInteger leftI = scrollView.contentOffset.x / screenW;
    NSInteger rightI = leftI + 1;
    
    //获取左边按钮
    UIButton *leftBtn = self.titleButtons[leftI];
    
    //获取右面btn
    NSInteger count = self.titleButtons.count;
    
    UIButton *rightBtn ;
    if (rightI < count) {
        
        rightBtn = self.titleButtons[rightI];
    }
    
    //计算缩放比例
    CGFloat scaleR = scrollView.contentOffset.x / screenW;
    scaleR -= leftI;
    
    CGFloat scaleL = 1 - scaleR;
    
    //缩放按钮
    leftBtn.transform = CGAffineTransformMakeScale(scaleL * 0.3 + 1, scaleL * 0.3 +1);
    rightBtn.transform = CGAffineTransformMakeScale(scaleR * 0.3 + 1, scaleR * 0.3 + 1);
    
    //颜色渐变
    UIColor *rightColer = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    
    [rightBtn setTitleColor:rightColer forState:UIControlStateNormal];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    
}















@end
