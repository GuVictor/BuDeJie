//
//  ViewController.h
//  网易新闻
//
//  Created by 古伟东 on 2017/3/16.
//  Copyright © 2017年 victorgu. All rights reserved.



/*
 演示网易新闻的利用
 子控制器 只有继承ViewControl就行了, 在viewdidload添加子控制器就可以
 
 - (void)setupAllChildViewController {
 UITableViewController *vc1 = [[UITableViewController alloc] init];
 vc1.view.backgroundColor = [UIColor blueColor];
 vc1.title = @"头条";
 [self addChildViewController:vc1];
 
 UITableViewController *vc2 = [[UITableViewController alloc] init];
 vc2.view.backgroundColor = [UIColor yellowColor];
 vc2.title = @"热点";
 [self addChildViewController:vc2];
 
 UITableViewController *vc3 = [[UITableViewController alloc] init];
 vc3.view.backgroundColor = [UIColor grayColor];
 vc3.title = @"视频";
 [self addChildViewController:vc3];
 
 UITableViewController *vc4 = [[UITableViewController alloc] init];
 vc4.view.backgroundColor = [UIColor purpleColor];
 vc4.title = @"社会";
 [self addChildViewController:vc4];
 
 UITableViewController *vc5 = [[UITableViewController alloc] init];
 vc5.view.backgroundColor = [UIColor orangeColor];
 vc5.title = @"订阅";
 [self addChildViewController:vc5];
 
 }
 
 */
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

