//
//  GWDEssenceViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/10.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDEssenceViewController.h"

//UIBarButtonItem:描述按钮具体的内容
//UINavigationItem:设置导航条上内容（左边，右边，中间）
//tabBarItem: 设置tabBar上按钮内容（tabBarButton）

@interface GWDEssenceViewController ()

@end

@implementation GWDEssenceViewController

#pragma mark - View生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条
    [self setUpNavBar];
    
    //设置scrollVIew
    [self setupScrollView];
    
    //设置标题栏
    [self setupTitlesView];
    
    
}

- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    
//    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
//    [scrollView addSubview:sw];//注意在导航控制器下 向scrollView中添加子控件，一定是向scrollView中添加， 会默认往下移64；自动调整scrll顶部的内边距为64，让srollview的内容往下移64

}

- (void)setupTitlesView {
    UIView *titleView = [[UIView alloc] init];
    //设置半透明颜色的三种方式
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    //    titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    //    titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    
    //子控制器会继承父控制器设置的透明度，如果父控制器透明，子控制器也透明；
    titleView.frame = CGRectMake(0, 64, self.view.gwd_width, 35);
    [self.view addSubview:titleView];
    
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

#pragma mark - 点击左侧按钮
- (void)game {
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}

#pragma mark - 点击右侧按钮
- (void)random:(UIButton *)button {
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}












@end
