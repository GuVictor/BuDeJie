//
//  GWDMeViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/10.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDMeViewController.h"
#import "GWDSettingViewController.h"
#import "GWDSquareCollectionViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "GWDSquareItem.h"
@interface GWDMeViewController ()<UICollectionViewDataSource>

@property (strong, nonatomic) NSArray<GWDSquareItem *> *squareItems;
@property (weak, nonatomic) UICollectionView *collectionView;

@end
/*
 搭建基本结构 -> 设置底部条 -> 设置顶部条 -> 设置顶部条标题字体 -> 处理导航控制器业务逻辑(跳转)
 
 */
@implementation GWDMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条
    [self setupNavBar];
    
    //设置tableView底部视图
    [self setupFootView];
    
    
    //展示方块内容 -> 请求数据
    [self loadData];
}

#pragma mark - 请求数据
- (void)loadData {
    //1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //2.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    
    //3.发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//        [responseObject writeToFile:@"/Users/guweidong/Desktop/plist文件/me.plist" atomically:YES];
        NSArray *dictArr = responseObject[@"square_list"];
        
        //字典数组转换成模型数组
        _squareItems = [GWDSquareItem mj_objectArrayWithKeyValuesArray:dictArr];
        
        //刷新collection表格
        [self.collectionView reloadData];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 设置tableView底部视图 
- (void)setupFootView {
    /*
     1.初始化要设置的流水布局
     2.cell必须要注册
     3.cell必须要自定义
     
     */
    
    //创建布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置cell尺寸
    NSInteger cols = 4;
    CGFloat margin = 1;
    CGFloat itemWH = (GWDScreenW - (cols - 1) * margin) / cols;
    flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
    flowLayout.minimumLineSpacing = margin;
    flowLayout.minimumInteritemSpacing = margin;
    
    //创建UIcollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = self.tableView.backgroundColor;//设置间距颜色
    self.tableView.tableFooterView = collectionView;
    _collectionView = collectionView;
    
    //设置数据源
    collectionView.dataSource = self;
    
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GWDSquareCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([self class])];
    
}

#pragma mark - dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.squareItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GWDSquareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    cell.item = self.squareItems[indexPath.row];
    
    return cell;
}



#pragma mark - 设置导航条
- (void)setupNavBar {
    //右边按钮
    //把UIButton暴走成UIBarButtonItem.就导致按钮点击区域扩大
    UIBarButtonItem *btnSettiongItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    UIBarButtonItem *nightBtnItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selLimage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    
    self.navigationItem.rightBarButtonItems = @[btnSettiongItem, nightBtnItem];
    
    //titleView
    self.navigationItem.title = @"我的";
}


#pragma mark - 点击设置按钮处理的事情
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

#pragma mark - 切换模式，是白天还是黑夜
- (void)night:(UIButton *)button {
    button.selected = !button.selected;
}





@end
