//
//  GWDTabBarController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/10.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDTabBarController.h"
#import "GWDEssenceViewController.h"
#import "GWDFriendTrendViewController.h"
#import "GWDMeViewController.h"
#import "GWDNewViewController.h"
#import "GWDPublishViewController.h"
#import "GWDNavgationController.h"
#import "GWDTabBar.h"

#import "UIImage+OriginalImage.h"


@interface GWDTabBarController ()

@end

@implementation GWDTabBarController
#warning TODO:发布按钮显示不出来
/*
    问题
    1.选中按钮的图片被渲染 -> iOS7之后默认tabBar上按钮图片都会被渲染 1.修改图片(在图片属性中修改) 2.通过代码
    2.选中按钮的标题颜色：黑色 标题字体大 -> 对应子控制器的tabBarItem
    3.发布按钮显示不出来 分析：为什么其他图片可以显示，我的图片不能显示 => 发布按钮图片太大，导致显示不出来 => 达不到高亮状态
 
    1 解决：不能修改图片尺寸，效果：让发布图片居中
 
    2，如何解决：系统的tabbar上按钮状态只有选中没有高亮状态 => 中间发布按钮 不能用系统tabBarButton => 发布按钮 不是 tabBarController子控制器
 
        1)自定义tabBar
 */

//只会调用一次, 而initialize会调用多次
+ (void)load {
    //获取捏个类中的appearance
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    // 设置按钮选中标题的颜色:富文本:描述一个文字颜色,字体,阴影,空心,图文混排
    // 创建一个描述文本属性的字典
    
    NSMutableDictionary *attrsDict = [NSMutableDictionary dictionary];
    attrsDict[NSForegroundColorAttributeName] = [UIColor blackColor];
    [tabBarItem setTitleTextAttributes:attrsDict forState:UIControlStateSelected];
    
    //设置字体尺寸：只有设置正常状态下，才会有效果
    NSMutableDictionary *attrsNormal = [NSMutableDictionary dictionary];
    attrsNormal[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [tabBarItem setTitleTextAttributes:attrsNormal forState:UIControlStateNormal];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加子控制器(5个子控制器) -> 自定义控制器 -> 划分项目文件结构
    [self setupAllChildViewController];
    
    //自定义tabBar
    [self setupTabBar];
    
    
}

- (void)setupAllChildViewController {
    //精华
    GWDEssenceViewController *essenceVc = [[GWDEssenceViewController alloc] init];
    [self setUpOneChildVC:essenceVc image:[UIImage imageNamed:@"tabBar_essence_icon"] selImage:[UIImage imageOriginalWithName:@"tabBar_essence_click_icon"] title:@"精华"];
    
    //新帖
    GWDNewViewController *newVc = [[GWDNewViewController alloc] init];
    [self setUpOneChildVC:newVc image:[UIImage imageNamed:@"tabBar_new_icon"] selImage:[UIImage imageOriginalWithName:@"tabBar_new_click_icon"] title:@"新帖"];
    
//    //发布(不能是系统的tabBarButton)
//    GWDPublishViewController *publishVc = [[GWDPublishViewController alloc] init];
//    [self setUpOneChildVC:publishVc image:[UIImage imageOriginalWithName:@"tabBar_publish_icon"] selImage:[UIImage imageOriginalWithName:@"tabBar_publish_click_icon"] title:@"发布"];
//    //设置图片位置
//    publishVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //关注
     GWDFriendTrendViewController *friendTrendVc = [[GWDFriendTrendViewController alloc] init];
    [self setUpOneChildVC:friendTrendVc image:[UIImage imageNamed:@"tabBar_friendTrends_icon"] selImage:[UIImage imageOriginalWithName:@"tabBar_friendTrends_click_icon"] title:@"关注"];
    
    //我
//    GWDMeViewController *meVc = [[GWDMeViewController alloc] init];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([GWDMeViewController class]) bundle:nil];
    GWDMeViewController *meVc = [storyBoard instantiateInitialViewController];
    [self setUpOneChildVC:meVc image:[UIImage imageNamed:@"tabBar_me_icon"] selImage:[UIImage imageOriginalWithName:@"tabBar_me_click_icon"] title:@"我"];
    
    
}

- (void)setUpOneChildVC:(UIViewController *)vc image:(UIImage *)image selImage:(UIImage *)selImage title:(NSString *)title {
    GWDNavgationController *nav = [[GWDNavgationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = image;
    nav.tabBarItem.selectedImage = selImage;
    
    [self addChildViewController:nav];
}

#pragma mark - 自定义tabBar
- (void)setupTabBar {
    GWDTabBar *tabBar = [[GWDTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
}




@end
