//
//  GWDFriendTrendViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/10.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDFriendTrendViewController.h"

@interface GWDFriendTrendViewController ()

@end

@implementation GWDFriendTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    
    NSMutableDictionary *attrsDict = [NSMutableDictionary dictionary];
    attrsDict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [self.navigationController.navigationBar setTitleTextAttributes:attrsDict];
    
}

- (void)setupNavBar {
    //左边按钮
    //把UIButton暴走成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon"] target:self action:@selector(friendRecomment)];
    
    self.navigationItem.title = @"我的关注";
}
- (void)friendRecomment {
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}


@end
