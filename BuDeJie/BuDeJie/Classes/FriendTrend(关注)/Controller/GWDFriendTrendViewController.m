//
//  GWDFriendTrendViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/10.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDFriendTrendViewController.h"
#import "GWDLoginRegisterViewController.h"
#import "UITextField+Placeholder.h"
#import "GWDLoginTextField.h"
@interface GWDFriendTrendViewController ()
//@property (weak, nonatomic) IBOutlet GWDLoginTextField *textFiled;

@end

@implementation GWDFriendTrendViewController
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    
    //分析:为什么先设置占位位置颜色,就没有效果 => 占位文字label拿不到
    //1.保存起来
    //设置占位文字颜色
//    _textFiled.placeholderColor = [UIColor blueColor];
    //设置占位位置:每次设置占位文字的后，再拿到之前保存占位文字颜色，重新设置
//    [_textFiled setGwd_PlaceHoder:@"hello"];
//    _textFiled.placeholder = @"hello";
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:GWDTabBarButtonDidRepeatClickNotification object:nil];
    
    
}

#pragma mark - tabBarButtonDidRepeatClick

- (void)tabBarButtonDidRepeatClick {
    if (self.view.window == nil) return;
    NSLog(@"%s, line = %d, Friend" , __FUNCTION__, __LINE__);
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
