//
//  GWDNewViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/10.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDNewViewController.h"
#import "GWDSubTagTableVC.h"
@interface GWDNewViewController ()

@end

@implementation GWDNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:GWDTabBarButtonDidRepeatClickNotification object:nil];
    
}

#pragma mark - tabBarButtonDidRepeatClick

- (void)tabBarButtonDidRepeatClick {
    if (self.view.window == nil) return;
    NSLog(@"%s, line = %d, New" , __FUNCTION__, __LINE__);
}
- (void)setupNavBar {
    //左边按钮
    //把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(mainTag)];
}

- (void)mainTag {
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    //进入推荐标签界面
    GWDSubTagTableVC *subTag = [[GWDSubTagTableVC alloc] init];
    
    [self.navigationController pushViewController:subTag animated:YES];
    
}
@end
