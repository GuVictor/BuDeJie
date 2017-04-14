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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

#pragma mark - 设置导航条
- (void)setUpNavBar {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:self action:@selector(random:)];
}

- (void)game {
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}
- (void)random:(UIButton *)button {
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}
@end
