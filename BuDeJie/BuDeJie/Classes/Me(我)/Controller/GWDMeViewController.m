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
#import "GWDWebViewController.h"
//#import <SafariServices/SafariServices.h>

static NSInteger cols = 4;
static CGFloat margin = 1;
#define itemWH ( GWDScreenW - (cols - 1) * margin ) / cols


@interface GWDMeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray<GWDSquareItem *> *squareItems;
@property (weak, nonatomic) UICollectionView *collectionView;

@end
/*
 搭建基本结构 -> 设置底部条 -> 设置顶部条 -> 设置顶部条标题字体 -> 处理导航控制器业务逻辑(跳转)
 
 */
@implementation GWDMeViewController

#pragma mark - View生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条
    [self setupNavBar];
    
    //设置tableView底部视图
    [self setupFootView];
    
    
    //展示方块内容 -> 请求数据
    [self loadData];
    
    //处理cell间距 -> 默认tableView分组样式，有额外头部和尾部
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = GWDMarin;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0); // 35 - 15 = 10
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:GWDTabBarButtonDidRepeatClickNotification object:nil];
    
    
}

#pragma mark - tabBarButtonDidRepeatClick

- (void)tabBarButtonDidRepeatClick {
    if (self.view.window == nil) return;
    NSLog(@"%s, line = %d, Me" , __FUNCTION__, __LINE__);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //2017-04-16 17:01:47.291 BuDeJie[3162:214209] {64, 0, 49, 0} 默认滚动范围64，49是collectionView算出来的
//    NSLog(@"%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
}

#pragma mark - 打印cell值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //2017-04-16 17:01:50.214 BuDeJie[3162:214209] {{0, 35}, {375, 44}} 静态的默认头部加35，也算是tableView的frame
    NSLog(@"%@", NSStringFromCGRect(cell.frame));
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
        
        //处理数据
        [self resloveData];
        
        //设置collectionview的高度  计算collectionView高度 = rows * itemWH
        //rows = (count - 1) / cols + 1(没有补齐时)
        
//        NSInteger count = self.squareItems.count;
//        NSInteger rowAllcount = (count - 1) / cols + 1;
        
        
        
        NSInteger rows = self.squareItems.count / cols;//(有补齐)
        //设置collectionView高度
        self.collectionView.gwd_height = rows * itemWH;
        
        
        //设置tableView的滚动范围(自动计算)
        self.tableView.tableFooterView = self.collectionView;
        
        
        
        //刷新collection表格
        [self.collectionView reloadData];
        
    
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 处理请求完成数据
- (void)resloveData {
    //判断下缺几个,创建几个补齐
    //3 % 4 = 3 cols - 3 = 1
    //5 % 4 = 1 cols - 1 = 3
    NSInteger count = self.squareItems.count;
    NSInteger exter = count % cols;
    if (exter) {
        exter = cols - exter;
        for (int i = 0; i<exter; i++) {
            GWDSquareItem *item = [[GWDSquareItem alloc] init];
            [self.squareItems addObject:item];
        }
    }
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
    collectionView.delegate = self;
    
    //设置collectionVIew不能滚动
    collectionView.scrollEnabled = NO;
    
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GWDSquareCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([self class])];
    
}



#pragma mark - 九宫格dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.squareItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GWDSquareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    cell.item = self.squareItems[indexPath.row];
    
    return cell;
}

#pragma mark - 九宫格点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //跳转界面 push 网页
    /*
     1.Safari openUrl ;自带很多功能(进度条，刷新，前进，倒退的功能)，必须要跳出当前应用
     2.uiwebview (没有功能)当前应用打开网页,并且有Safari，自己实现，uiwebView不能实现进度条
     3.SFSafariViewController：专门用来展示网页 需求：即想要在当前应用展示，又想要Safari的工功能，可息只要iOS 9才能用
     
     4wkwebView
     */
    
    GWDSquareItem *item = self.squareItems[indexPath.row];
//    NSLog(@"%@", item.url);
    if (![item.url containsString:@"http"]) {
//        return;
#warning 如果不是http格式，暂时化为百度先
        item.url = @"https://www.baidu.com";
    }
    
    NSURL *url = [NSURL URLWithString:item.url];
    
    //SFSafariViewController使用modal苹果推荐
//    SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:url];
//    [self presentViewController:safariVc animated:YES completion:nil];
    
    GWDWebViewController *webVc = [[GWDWebViewController alloc] init];
    webVc.url = url;
    [self.navigationController pushViewController:webVc animated:YES];
    
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
