//
//  GWDTopicBaseViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/5/4.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDTopicBaseViewController.h"
#import <AFNetworking.h>
#import "GWDTopic.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "GWDTopicCell.h"
#import "NSDictionary+Property.h"
#import <MJRefresh.h>
@interface GWDTopicBaseViewController ()

/** 当前帖子数据的描述信息，专门有了加载下一页数据 */
@property (copy, nonatomic) NSString *maxtime;

/** 所有提帖子数据量 */
@property (strong, nonatomic) NSMutableArray<GWDTopic *> *topics;

/** 请求管理者 */
@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation GWDTopicBaseViewController
/** 在这里实现tpye方法，仅仅是为了消除警告 */
- (GWDTopicType)type {return 0;};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置背景颜色
    self.view.backgroundColor = GWDGrayColor(206);
    
    self.tableView.contentInset = UIEdgeInsetsMake(GWDNavMaxY + GWDTitlesViewH , 0, GWDTabBarH, 0);
    
    
    //设置分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置指示器的偏移量
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    //减少heightForRowAtIndexPath方法的调用
    //设置cell的估算高度，每一行大约都是（或者使用代理方法）
    //    self.tableView.estimatedRowHeight = 100;
    
    //添加监听器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:GWDTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:GWDTitleButtonDidRepeatClickNotification object:nil];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GWDTopicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GWDTopicCell class])];
    
    //设置刷新view(包括下拉刷新，和上拉刷新)
    [self setupRefresh];
}

#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - 设置tableFooterView为刷新更多数据
- (void)setupRefresh {
    //广告条
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 0, 30);
    
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.text = @"广告";
    label.textAlignment = NSTextAlignmentCenter;
    
    self.tableView.tableHeaderView = label;
    
    //设置头部刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    //自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //让header自动刷新
    [self.tableView.mj_header beginRefreshing];
    
    //footer
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
    
    
}

#pragma mark - 移除监听器
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听tabBarButton重复点击
- (void)tabBarButtonDidRepeatClick {
    //重复点击的不是精华按钮 直接返回
    if (self.view.window == nil) return;
    
    //如果显示在正中间的不是GWDAllTableViewController 直接返回
    if (self.tableView.scrollsToTop == NO) return;
    
    NSLog(@"%s调用开始刷新数据, line = %d", __FUNCTION__, __LINE__);
    [self.tableView.mj_header beginRefreshing];
    
    
}

#pragma mark - 监听标题按钮的重复点击
- (void)titleButtonDidRepeatClick {
    //因为按钮重复点击的事情和精华按钮重复点击一样
    [self tabBarButtonDidRepeatClick];
}

#pragma mark - 请求服务器数据处理
/**
 发送请求给服务器，下拉请求新数据
 */
- (void)loadNewTopics {
    GWDLog(@"发送请求给服务器，下拉刷新数据");
    
    //1.取消所有的请求，并且关闭session(注意：一旦关闭了session，这个manager再也无法发送任何请求)
    //    [self.manager invalidateSessionCancelingTasks:YES];不可行
    
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];//它会调用失败的方法
    
    
    //1.创建请求会话管理者
    //    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);//这里发送@1(NSNumber)也是可行的, 31表示音频数据
    
    
    //3.发送请求
    [self.manager GET:GWDCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@", responseObject);
        GWDAFNWriteToPlist(topic)
        //        [responseObject writeToFile:@"/Users/guweidong/Desktop/plist文件/me1.plist" atomically:YES];//记住在模拟器运行才能写入电脑桌面
        
        //        [responseObject[@"list"][0] createPropertyCode];
        //无论是上拉还是下拉都有储存maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        //覆盖以前的
        self.topics =  [GWDTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        NSLog(@"%s, line = %d  %ld", __FUNCTION__, __LINE__, self.topics.count);
        //刷新表格
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
        if (error.code != NSURLErrorCancelled) {
            
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试!"];
        }
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}


/**
 发送请求给服务器，上拉加载更多数据
 */
- (void)loadMoreTopics {
    NSLog(@"%s, line = %d发送请求给服务器 - 加载更多数据", __FUNCTION__, __LINE__);
    
    
    //1.创建会话管理者
    //    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);//这里发送@1也可行的
    parameters[@"maxtime"] = self.maxtime;
    
    //3.发送请求
    [self.manager GET:GWDCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        
        //字典转模型
        NSArray *moreTopics = [GWDTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //累计到旧数组的后面
        [self.topics addObjectsFromArray:moreTopics];
        NSLog(@"%s, line = %d  %ld", __FUNCTION__, __LINE__, self.topics.count);
        
#warning 刷新表格，contentoffset会改变吗
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        //        if (self.topics.count >= 60) {
        //            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        //        } else {
        //            [self.tableView.mj_footer endRefreshing];
        //        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (error.code != NSURLErrorCancelled) {
            
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试"];
        }
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - tableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //在这个方法监听有没有数据，没有就隐藏footView
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // control + command + 空格 -> 弹出emoji表情键盘
    //    cell.textLabel.text = @"⚠️哈哈";
    
    GWDTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GWDTopicCell class])];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

#pragma mark - tableView代理
/**
 这个方法的特点：
 1.默认情况下
 1> 每次刷新表格时，有多少数据，这个方法就一次性调用多少次（比如有100条数据，每次reloadData时，这个方法就会一次性调用100次）
 2> 每当有cell进入屏幕范围内，就会调用一次这个方法
 */

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    GWDTopic *topic = self.topics[indexPath.row];
//
//    return topic.cellHeight;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.topics[indexPath.row].cellHeight;
}


#pragma mark - scrollView代理方法


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //清除缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
    //    NSLog(@"%@", NSStringFromCGPoint(self.tableView.contentOffset));
    
    // 设置缓存时长为1个月
    //    [SDImageCache sharedImageCache].maxCacheAge = 30 * 24 * 60 * 60;
    
    // 清除沙盒中所有使用SD缓存的过期图片（缓存时长 > 一个星期）
    //    [[SDImageCache sharedImageCache] cleanDisk];
    
    // 清除沙盒中所有使用SD缓存的图片
    //    [[SDImageCache sharedImageCache] clearDisk];
}



@end

