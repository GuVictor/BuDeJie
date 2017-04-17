//
//  GWDSettingViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/13.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDSettingViewController.h"
#import <SDImageCache.h>

@interface GWDSettingViewController ()

@end

@implementation GWDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条左边按钮
    self.title = @"设置";
    
    //设置右边
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"jump" style:0 target:self action:@selector(jump)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    
}

- (void)jump {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - tableView 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    //计算缓存数据，计算整个应用程序缓存数据 => 沙盒(Cache) => 获取cache文件夹尺寸
    
    //SDWebImage：帮我们做了缓存
    NSInteger size = [SDImageCache sharedImageCache].getSize;
    
    [self getFileSize];
    cell.textLabel.text = [NSString stringWithFormat:@"清除缓存,%ld", size];
    
    return cell;
}

#pragma mark - tableView的数据源
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    
}

/*
 /Users/guweidong/Library/Developer/CoreSimulator/Devices/AA5F0959-8824-4AEE-9EC2-E8F15852F985/data/Containers/Data/Application/DBF155C0-D176-408B-8C55-CBB737A2EEE1/Library/Caches/default/com.hackemist.SDWebImageCache.default/0ba18a32270775194993b5ae505c4895.jpg
 
 */

#pragma mark - 计算缓存大小
- (void)getFileSize {
//    NSFileManager
//attributesOfItemAtPath:指定文件路径,就能获取文件属性
    //把所有尺寸加起来
    
    //获取caches文件路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //获取default文件路径
    NSString *defaultPath = [cachePath stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default/0ba18a32270775194993b5ae505c4895.jpg"];
    
    //遍历文件间，一个一个加起来
    
    //获取文件管理者
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    //获取文件属性
    // attributesOfItemAtPath:只能获取文件尺寸,获取文件夹不对,
    NSDictionary *attr = [mgr attributesOfItemAtPath:defaultPath error:nil];
    
    //default
    NSInteger fileSize = [attr fileSize];
    
    NSLog(@"%ld", fileSize);



}



















@end
