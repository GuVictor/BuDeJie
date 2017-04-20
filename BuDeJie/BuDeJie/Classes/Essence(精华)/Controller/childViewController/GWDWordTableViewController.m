//
//  GWDWordTableViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/18.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDWordTableViewController.h"

@interface GWDWordTableViewController ()

@end

@implementation GWDWordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GWDRandomColor;
    
       self.tableView.contentInset = UIEdgeInsetsMake(GWDNavMaxY + GWDTitlesViewH, 0, GWDTabBarH, 0);
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:GWDTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:GWDTitleButtonDidRepeatClickNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听tabBarButton重复点击
- (void)tabBarButtonDidRepeatClick {
    //重复点击的不是精华按钮 直接返回
    if (self.view.window == nil) return;
    
    //如果显示在正中间的不是GWDAllTableViewController 直接返回
    if (self.tableView.scrollsToTop == NO) return;
    
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    
}

#pragma mark - 标题按钮的重复点击
- (void)titleButtonDidRepeatClick {
    //因为按钮重复点击的事情和精华按钮重复点击一样
    [self tabBarButtonDidRepeatClick];
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%zd", self.class, indexPath.row];
    return cell;
}

@end
