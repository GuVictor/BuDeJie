//
//  GWDSettingViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/13.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDSettingViewController.h"
#import <SDImageCache.h>
#import "GWDFileTool.h"

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface GWDSettingViewController ()

@end

@implementation GWDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条左边按钮
    self.title = @"设置";
    
    //设置右边导航条
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"jump" style:0 target:self action:@selector(jump)];
    
    //注册cell
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
    double sizeMB = size / 1000.0 / 1000.0;
    NSLog(@"%ld  %d", size, __LINE__);
    
   
//    cell.textLabel.text = [NSString stringWithFormat:@"清除缓存,%ld", size];
    cell.textLabel.text = [self sizeStr];
    
    return cell;
}

#pragma mark - tableView的数据源
//清空缓存
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    //获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    //获取cache文件夹下所有文件, 不包括子路径的子路径
    NSString *defalutPath =  [CachePath stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    [GWDFileTool removeDirectoryPath:defalutPath];
    //拿到的是子文件和文件夹（不包括它下面的下面的子路径）
    /*
     ( 
         ".DS_Store",
         "fa6350dbfd1b72e85578af8da20b641e.jpg",
         victor

     )
     */
    //一删除什么也删除了
    
    /*
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:defalutPath error:nil];//它文件夹下的文件或者文件夹（不包括子文件夹和子文件夹里面的文件）
    NSLog(@"%@   %d", subPaths, __LINE__);
    
    for (NSString *subPath in subPaths) {
        //拼接全路径
        NSString *filePath = [defalutPath stringByAppendingPathComponent:subPath];
        
        //删除路径
        [mgr removeItemAtPath:filePath error:nil];
        
    }
     */
    
    [self.tableView reloadData];
    
}

#pragma mark - 获取百思缓存尺寸字符串
- (NSString *)sizeStr {
//    获取文件夹路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *defalutPath =  [cachePath stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    NSLog(@"%@, %d", defalutPath, __LINE__);
    
     NSInteger totalSize =  [GWDFileTool getFileSize:defalutPath];
    NSLog(@"%ld   %d", totalSize, __LINE__);
    
    NSString *sizeStr = @"清除缓存";
    
    
    if (totalSize > 1000 * 1000) {
        //MB
        
        CGFloat sizeF = totalSize / 1000.0 /1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fMB)", sizeStr, sizeF];
    }else if (totalSize > 1000) {
        //KB
        CGFloat sizeF = totalSize / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fKB)", sizeStr, sizeF];

    }else if (totalSize > 0) {
        sizeStr = [NSString stringWithFormat:@"%@(%ldB)", sizeStr, totalSize];
    }
    
    return sizeStr;
    
}

#pragma mark - 计算缓存大小
- (NSInteger)getFileSize:(NSString *)directoryPath {
    //NSFileManager
    //attributesOfItemAtPath:指定文件路径,就能获取文件属性
    //把所有尺寸加起来
    
//    //获取caches文件路径
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//    //获取default文件路径
//    NSString *defaultPath = [cachePath stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default/0ba18a32270775194993b5ae505c4895.jpg"];
//    遍历文件间，一个一个加起来

    //    获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    //获取文件下所有的子路径(包含子路径的子路径), 打印显示时文件用双引号，文件夹没引号，文件夹的子路径文件也打印出来
    /*
     ( ".DS_Store",
     "fa6350dbfd1b72e85578af8da20b641e.jpg",
     victor,
     "victor/857467d804301b68e44e82622e28cf5b.jpg" )
     */
    
    NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
    NSLog(@"%@    %d", subPaths , __LINE__);
    
    NSInteger totalSize = 0;
    
    for (NSString *subPath in subPaths) {
        //获取文件全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        //判断隐藏文件
        if ([filePath containsString:@".DS"]) continue;
        
        //判断是否是文件夹
        BOOL isDirectory;
        //判断文件是否存在，并且判断是否是文件夹
        BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
#warning <#message#>
        if (!isExist || isDirectory) {
            continue;
        }
        
        //获取文件属性
        // attributesOfItemAtPath:只能获取文件尺寸,获取文件夹不对,
        NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];

        //获取文件尺寸
        
        NSInteger fileSize = [attr fileSize];
        
        totalSize += fileSize;
    }

    return totalSize;
}



















@end
