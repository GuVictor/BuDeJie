//
//  GWDVoiceTableViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/18.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDVoiceTableViewController.h"

@interface GWDVoiceTableViewController ()

@end

@implementation GWDVoiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GWDRandomColor;
    
       self.tableView.contentInset = UIEdgeInsetsMake(GWDNavMaxY + GWDTitlesViewH, 0, GWDTabBarH, 0);
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
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
