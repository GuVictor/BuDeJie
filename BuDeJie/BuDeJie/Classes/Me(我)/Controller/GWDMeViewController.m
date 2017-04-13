//
//  GWDMeViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/10.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDMeViewController.h"
#import "GWDSettingViewController.h"
@interface GWDMeViewController ()

@end
/*
 搭建基本结构 -> 设置底部条 -> 设置顶部条 -> 设置顶部条标题字体 -> 处理导航控制器业务逻辑(跳转)
 
 */


@implementation GWDMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
}

- (void)setupNavBar {
    //右边按钮
    //把UIButton暴走成UIBarButtonItem.就导致按钮点击区域扩大
    UIBarButtonItem *btnSettiongItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    UIBarButtonItem *nightBtnItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selLimage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    
    self.navigationItem.rightBarButtonItems = @[btnSettiongItem, nightBtnItem];
    
    //titleView
    self.navigationItem.title = @"我的";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

- (void)setting {
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    
    //设置界面跳转
    GWDSettingViewController *settingVc = [[GWDSettingViewController alloc] init];
    //必须要在跳转之前设置
    settingVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:settingVc animated:YES];
    
    /*
        1.底部条没有隐藏
        2.处理返回按钮样式
     */
}

- (void)night:(UIButton *)button {
    button.selected = !button.selected;
}




@end
