//
//  GWDEssenceViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/10.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDEssenceViewController.h"
#import "GWDTitleButton.h"

#import "GWDAllTableViewController.h"
#import "GWDVideoTableViewController.h"
#import "GWDVoiceTableViewController.h"
#import "GWDPictureTableViewController.h"
#import "GWDWordTableViewController.h"

//UIBarButtonItem:描述按钮具体的内容
//UINavigationItem:设置导航条上内容（左边，右边，中间）
//tabBarItem: 设置tabBar上按钮内容（tabBarButton）
/*
 
    为了跨平台，mac 和 iPhone，退出技术一般有一个适应期，下个版本再取代
名字叫attributes并且是NSDictionary *类型的参数，它的key一般都有以下规律
1.iOS7开始
1> 所有的key都来源于： NSAttributedString.h
2> 格式基本都是：NS***AttributeName

2.iOS7之前
1> 所有的key都来源于： UIStringDrawing.h
2> 格式基本都是：UITextAttribute***
*/


@interface GWDEssenceViewController ()<UIScrollViewDelegate>
/** 标题栏 */
@property (weak, nonatomic) UIView *titleView;

/** 上次点击的标题按钮 */
@property (weak, nonatomic) GWDTitleButton *previousCLickTitleBtn;

/** 标题下面的下划线 */
@property (weak, nonatomic) UIView *titleUnderline;

/** 用来存放所有子控制器view的scrollVIew */
@property (weak, nonatomic) UIScrollView *scrollView;





@end

@implementation GWDEssenceViewController

#pragma mark - View生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置所有子控制器
    [self setupAllChildViewController];
    
    //设置导航条
    [self setUpNavBar];
    
    //设置scrollVIew
    [self setupScrollView];
    
    //设置标题栏
    [self setupTitlesView];
    
    //添加第一个 全部表格
    [self addChildVcViewIntoScrollView:0];
    
}

#pragma mark - 初始化所有子控制器
- (void)setupAllChildViewController {
    
    [self addChildViewController:[[GWDAllTableViewController alloc] init]];
    [self addChildViewController:[[GWDVideoTableViewController alloc] init]];
    [self addChildViewController:[[GWDVoiceTableViewController alloc] init]];
    [self addChildViewController:[[GWDPictureTableViewController alloc] init]];
    [self addChildViewController:[[GWDWordTableViewController alloc] init]];
}

#pragma mark - 初始化滚动视图
- (void)setupScrollView {
    
    //不予许自动修改UIScrollView
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //scrollView设置
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.frame = self.view.bounds;
    
    //隐藏指示器
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;//开启分页
    
    //点击状态栏的时候,这个scrollVIew不会滚动到最顶部
    scrollView.scrollsToTop = NO;
    
    //设置代理
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
//    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
//    [scrollView addSubview:sw];//注意在导航控制器下 向scrollView中添加子控件，一定是向scrollView中添加， 会默认往下移64；自动调整scrll顶部的内边距为64，让srollview的内容往下移64
    
    NSUInteger count = self.childViewControllers.count;
    CGFloat scrollViewW = scrollView.gwd_width;
//    CGFloat scrollViewH = scrollView.gwd_height;
    
//    for (NSInteger i = 0; i < count; i ++) {
//        //取出i位置子控制器的view
////        UITableViewController *vc = self.childViewControllers[i];
////        vc.tableView.contentInset = UIEdgeInsetsMake(35, 0, 120, 0);
//        
//        UIView *childVcView = self.childViewControllers[i].view;
//        childVcView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
//        [scrollView addSubview:childVcView];
//    }
    
    scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);

}

#pragma mark - 初始化标题按钮栏
- (void)setupTitlesView {
    UIView *titleView = [[UIView alloc] init];
    //设置半透明颜色的三种方式
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    //    titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    //    titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    
    //子控制器会继承父控制器设置的透明度，如果父控制器透明，子控制器也透明；
    titleView.frame = CGRectMake(0, 64, self.view.gwd_width, 35);
    
    [self.view addSubview:titleView];
    _titleView = titleView;
    //设置标题栏按钮
    [self setupTitleButtons];
    
    //设置下划线
    [self setupTitleUnderline];
    
}

#pragma mark - 往标题栏添加所有按钮
- (void)setupTitleButtons {
    //文字
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    NSInteger count = titles.count;
    
    //标题按钮的尺寸
    CGFloat titleBtnW = self.titleView.gwd_width / count;
    CGFloat titleBtnH = self.titleView.gwd_height;
    
    //创建5个按钮
    for (int i = 0; i < count; i++) {
        GWDTitleButton *titleButton = [[GWDTitleButton alloc] init];
        [titleButton addTarget:self action:@selector(clickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        //给按钮绑定一个标识
        titleButton.tag = i;
        
        //frame
        titleButton.frame = CGRectMake(i * titleBtnW, 0, titleBtnW, titleBtnH);
        //文字
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        //添加按钮
        [self.titleView addSubview:titleButton];
        
//        if (i == 0) {在这里的选中不好
//            [self clickTitleButton:titleButton];
//        }
        
        
    }
}

#pragma mark - 设置按钮底部的下划线
- (void)setupTitleUnderline {
    //标题按钮
    GWDTitleButton *firstTitleBtn = self.titleView.subviews.firstObject;
    
    //下划线
    UIView *titleUnderLine = [[UIView alloc] init];
    
    titleUnderLine.gwd_height = 2;
    titleUnderLine.gwd_y = self.titleView.gwd_height - titleUnderLine.gwd_height;
    
    titleUnderLine.backgroundColor = [firstTitleBtn titleColorForState:UIControlStateSelected];
    
    [self.titleView addSubview:titleUnderLine];
    self.titleUnderline = titleUnderLine;
    
    //切换按钮状态（不是三部曲，前面为空）
    firstTitleBtn.selected = YES;
    self.previousCLickTitleBtn = firstTitleBtn;
    
    [firstTitleBtn.titleLabel sizeToFit];//让label根据文字内容计算尺寸（开始的时候为0，因为在view将要显示的时候才会计算尺寸，这里强制让它算一下）
    
    self.titleUnderline.gwd_width = firstTitleBtn.titleLabel.gwd_width + GWDMarin;
    self.titleUnderline.gwd_centerX = firstTitleBtn.gwd_centerX;
    
}

#pragma mark - 设置导航条
- (void)setUpNavBar {
    
    //左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    //右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:self action:@selector(random:)];
    //中间titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

#pragma mark - 点击导航条左侧按钮
- (void)game {
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}

#pragma mark - 点击导航条右侧按钮
- (void)random:(UIButton *)button {
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}

#pragma mark - 点击标题按钮
- (IBAction)clickTitleButton:(GWDTitleButton *)btn {
//    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    if (self.previousCLickTitleBtn == btn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GWDTitleButtonDidRepeatClickNotification object:nil];
    }
    
    [self dealTitleButtonClikc:btn];
}

- (void)dealTitleButtonClikc:(GWDTitleButton *)btn {
    //选中按钮处理
    self.previousCLickTitleBtn.selected = NO;
    btn.selected = YES;
    self.previousCLickTitleBtn = btn;
    
    //选中按钮的下划线处理
    [UIView animateWithDuration:0.25 animations:^{
        
        //要自己算
        //        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        //        attributes[NSFontAttributeName] = btn.titleLabel.font;
        //        self.titleUnderline.gwd_width = [btn.currentTitle sizeWithAttributes:attributes].width;
        
        //简单的方法不用自己去计算宽度（titleLabel包着字体）
        self.titleUnderline.gwd_width = btn.titleLabel.gwd_width + GWDMarin;
        self.titleUnderline.gwd_centerX = btn.gwd_centerX;
        
        //知道按钮的标识，就知道偏移量是多少
        CGFloat offsetX = self.scrollView.gwd_width * btn.tag;
        //保持y值得的偏移量
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
        
    } completion:^(BOOL finished) {
        //完成动画添加控制器的view
        [self addChildVcViewIntoScrollView:btn.tag];
    }];
    
    //设置index文字对应的tableView.scrollsToTop = Yes,其他都设置为NO
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        
        //如果View还没有被裁剪,就不用去处理
        if (!childVc.isViewLoaded) {
            continue;
        }
        
        
        UIScrollView *scrollView = (UIScrollView *)childVc.view;//childVc.view这个会调Loadview加载5个view，所有前面做一个判断
        if (![scrollView isKindOfClass:[UIScrollView class]]) {
            continue;
        }
        
        scrollView.scrollsToTop = (i == btn.tag);
    }

}

#pragma mark - 加载控制器的view，点击那个加载那个
/**
 添加第index个子控制器的VIew到scrollView中

 */
- (void)addChildVcViewIntoScrollView:(NSInteger)index {
    //取出按钮索引对应的控制器
    UIViewController *childVc = self.childViewControllers[index];
    
    //如果view已经被加过，就直接返回（和下面一句不能反）
    if (childVc.isViewLoaded) {
        return;
    }
    
    //取出index位置对应的子控制器view
    UIView *childVcView = childVc.view;
    
    //设置子控制器view的frame
    CGFloat scrollViewW = self.scrollView.gwd_width;
    childVcView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.scrollView.gwd_height);
    
    // 设置子控制器view的frame
//    childVcView.frame = self.scrollView.bounds;
    
    [self.scrollView addSubview:childVcView];
}

#pragma mark - 滚动视图代理
/**
 正在滚动，减速也会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
//    CGFloat a =  scrollView.contentOffset.x / scrollView.gwd_width;
}


/**
 用户抬手离开，立即掉用，然后减速掉scrollViewDidScroll方法再到scrollViewDidEndDragging方法

 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}

/**
 *  当用户松开scrollView并且滑动结束时调用这个代理方法（scrollView停止滚动的时候）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    
    //计算btn的标识
    NSInteger index = scrollView.contentOffset.x / scrollView.gwd_width;
    //取出对应的btn
    GWDTitleButton *btn = self.titleView.subviews[index];
    
    //让按钮点击选中
//    [self clickTitleButton:btn];
    //因为滚动也有机会发生重复点击
    [self dealTitleButtonClikc:btn];
}

#pragma mark - 加载控制器的view的第二种方案没参数，点击那个加载那个

/*
 
 第二种没有参数的方案
- (void)addChildVcViewIntoScrollView
{
    CGFloat scrollViewW = self.scrollView.xmg_width;
    
    NSUInteger index = self.scrollView.contentOffset.x / scrollViewW;
    
    // 取出index位置对应的子控制器view
    UIView *childVcView = self.childViewControllers[index].view;
    
    // 设置子控制器view的frame
    childVcView.frame = self.scrollView.bounds;
    
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
    
    //    childVcView.frame = CGRectMake(self.scrollView.bounds.origin.x, self.scrollView.bounds.origin.y, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    
    //    childVcView.frame = CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    
    //    childVcView.frame = CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, scrollViewW, self.scrollView.xmg_height);
    
    //    childVcView.frame = CGRectMake(self.scrollView.contentOffset.x, 0, scrollViewW, self.scrollView.xmg_height);
    
    //    childVcView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.scrollView.xmg_height);
}

 */




@end
