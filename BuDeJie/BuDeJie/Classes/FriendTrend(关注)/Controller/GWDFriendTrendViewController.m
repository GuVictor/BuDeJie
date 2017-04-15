//
//  GWDFriendTrendViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/10.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDFriendTrendViewController.h"
#import "GWDLoginRegisterViewController.h"
@interface GWDFriendTrendViewController ()

@end

@implementation GWDFriendTrendViewController
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    
    
}
#pragma mark - 设置右侧导航条
- (void)setupNavBar {
    //左边按钮
    //把UIButton暴走成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendRecomment)];
    
    self.navigationItem.title = @"我的关注";
}
#pragma mark - 推荐关注
- (void)friendRecomment {
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}

#pragma mark - 点击立即登录注册按钮
- (IBAction)clickRegisterOrLogin:(id)sender {
    GWDLoginRegisterViewController *loginVc = [[GWDLoginRegisterViewController alloc] init];
    [self presentViewController:loginVc animated:YES completion:nil];
}

@end
