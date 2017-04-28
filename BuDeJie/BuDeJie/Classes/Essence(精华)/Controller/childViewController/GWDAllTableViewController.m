//
//  GWDAllTableViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/18.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDAllTableViewController.h"
#import <AFNetworking.h>
#import "GWDTopic.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "GWDTopicCell.h"
#import "NSDictionary+Property.h"
@interface GWDAllTableViewController ()

/** 当前帖子数据的描述信息，专门有了加载下一页数据 */
@property (copy, nonatomic) NSString *maxtime;

/** 模拟数据量 */
@property (strong, nonatomic) NSMutableArray *topics;

/**>>>>>>>>>>>>>>>>>>>>>上拉刷新>>>>>>>>>>>>>>>>>>>>>>>*/

/** 上拉刷新控件 */
@property (weak, nonatomic) UIView *footer;

/** 上拉刷新控件里面的文字 */
@property (weak, nonatomic) UILabel *footerLabel;

/** 上拉刷新控件时候正在刷新 */
@property (assign, nonatomic, getter = isFooterRefreshing)  BOOL footerRefreshing;
/**>>>>>>>>>>>>>>>>>>>>>上拉刷新>>>>>>>>>>>>>>>>>>>>>>>*/

/**>>>>>>>>>>>>>>>>>>>>>下拉刷新>>>>>>>>>>>>>>>>>>>>>>>*/
/** 下拉刷新控件 */
@property (weak, nonatomic) UIView  *header;
/** 下拉刷新控件里面的文字 */
@property (weak, nonatomic) UILabel *headerLabel;
/** 下拉属性控件是否正在刷新 */
@property (assign, nonatomic, getter=isHeaderRefreshing) BOOL  headerRefreshing;
/**>>>>>>>>>>>>>>>>>>>>>下拉刷新>>>>>>>>>>>>>>>>>>>>>>>*/

/** 请求管理者 */
@property (strong, nonatomic) AFHTTPSessionManager *manager;


@end

@implementation GWDAllTableViewController

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
    self.tableView.estimatedRowHeight = 100;
    
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
    
    //header
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, -50, self.tableView.gwd_width, 50);
    header.backgroundColor = [UIColor grayColor];
    
    //header里面的label
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = header.bounds;
    headerLabel.backgroundColor = [UIColor yellowColor];
    headerLabel.text = @"下拉可以刷新";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    //往header添加label
    [header addSubview:headerLabel];
    self.headerLabel = headerLabel;
    
    //往tableView添加子控件
    [self.tableView addSubview:header];
    self.header = header;
    
    //让header自动刷新
    [self headerBeginRefreshing];
    
    
    //footView
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, self.tableView.gwd_width, 35);
    
    self.tableView.tableFooterView = footer;
    self.footer = footer;
    
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.frame = footer.bounds;
    footerLabel.backgroundColor = [UIColor redColor];
    footerLabel.text = @"上拉可以加载更多";
    footerLabel.textColor = [UIColor whiteColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    
    [footer addSubview:footerLabel];
    self.footerLabel = footerLabel;
    
    
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
    [self headerBeginRefreshing];
    
    
}

#pragma mark - 监听标题按钮的重复点击
- (void)titleButtonDidRepeatClick {
    //因为按钮重复点击的事情和精华按钮重复点击一样
    [self tabBarButtonDidRepeatClick];
}

#pragma mark - tableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //在这个方法监听有没有数据，没有就隐藏footView
    self.footer.hidden = (self.topics.count == 0);
    
    
    return self.topics.count;
}

#pragma mark - tableView代理
/**
 这个方法的特点：
 1.默认情况下
 1> 每次刷新表格时，有多少数据，这个方法就一次性调用多少次（比如有100条数据，每次reloadData时，这个方法就会一次性调用100次）
 2> 每当有cell进入屏幕范围内，就会调用一次这个方法
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWDTopic *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    // control + command + 空格 -> 弹出emoji表情键盘
    //    cell.textLabel.text = @"⚠️哈哈";

    GWDTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GWDTopicCell class])];
    
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //处理footer
    [self dealFooter];
    
    //处理header
    [self dealHeader];
    
}

//处理footer
- (void)dealFooter {
    //还没有任何内容的时候，不需要判断
    if (self.tableView.contentSize.height == 0) return;
    
    //如果正在刷新,直接返回
    if (self.isFooterRefreshing) return;

#warning <#message#>
//    if (self.isHeaderRefreshing) return;
    
    //当scrollView的偏移量y值 >= ofsetY是, 代表footer意见完全出现
    CGFloat ofsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.gwd_height;
    
    //判断的是上拉并且 大于一定的偏移量
    if (self.tableView.contentOffset.y >= ofsetY && self.tableView.contentOffset.y > -(self.tableView.contentInset.top) ) {
        //进入刷新状态

        [self footerBeginRefreshing];
    }

}

- (void)dealHeader {
    //如果正在下拉刷新,直接返回
    if (self.isHeaderRefreshing) return;
    
    //当scro的偏移量y值 <= offsetY时，代表header已经完全出现
    CGFloat offsetY = - (self.tableView.contentInset.top + self.header.gwd_height);
    
    if (self.tableView.contentOffset.y <= offsetY) {
        //header已经完全出现
        self.headerLabel.text = @"松开立即刷新";
        self.headerLabel.backgroundColor = [UIColor grayColor];
        
    }else {
        self.headerLabel.text = @"下拉可以刷新";
        self.headerLabel.backgroundColor = [UIColor redColor];
    }
}

/**
 用户松开scrollView时调用

 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {//改变内边距会影响contentOffSet
    //如果正在下拉刷新，直接返回
    if (self.isHeaderRefreshing) return;
    
    CGFloat offsetY = - (self.tableView.contentInset.top + self.header.gwd_height);
    if (self.tableView.contentOffset.y <= offsetY) {
        //header已经完全出现
        
        //进入下拉刷新状态
        [self headerBeginRefreshing];
        
    }
    
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
    parameters[@"type"] = @"31";//这里发送@1(NSNumber)也是可行的, 31表示音频数据
    
    
    //3.发送请求
    [self.manager GET:GWDCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//        GWDAFNWriteToPlist(topic)
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
        [self headerEndRefreshing];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
        if (error.code != NSURLErrorCancelled) {
            
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试!"];
        }
        
        //结束刷新
        [self headerEndRefreshing];
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
    parameters[@"type"] = @"31";//这里发送@1也可行的
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
        [self footerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (error.code != NSURLErrorCancelled) {
            
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试"];
        }
        
        //结束刷新
        [self footerEndRefreshing];
    }];
    
}

#pragma mark - 头部刷新处理
/**>>>>>>>>>>>>>>>>>>>>>头部开始刷新>>>>>>>>>>>>>>>>>>>>>>>*/

- (void)headerBeginRefreshing {
    //如果正在下拉刷新，直接返回
    if (self.isHeaderRefreshing) return;

//    if (self.isFooterRefreshing) return;
    
    //进入下拉刷新状态
    self.headerLabel.text = @"正在刷新数据...";
    self.headerLabel.backgroundColor = [UIColor blueColor];
    self.headerRefreshing = YES;
    
    //增加内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top += self.header.gwd_height;//增加的高度
        
        self.tableView.contentInset = inset;
        
#warning (self.tableView.contentInset.top)
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, - inset.top);
    }];
    
    [self loadNewTopics];

}

/**>>>>>>>>>>>>>>>>>>>>>头部结束刷新>>>>>>>>>>>>>>>>>>>>>>>*/

- (void)headerEndRefreshing {
    self.headerRefreshing = NO;
    //减少内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top -= self.header.gwd_height;
        
        self.tableView.contentInset = inset;//还原内边距
    }];
}

#pragma mark - 尾部刷新处理
/**>>>>>>>>>>>>>>>>>>>>>尾部开始刷新>>>>>>>>>>>>>>>>>>>>>>>*/

- (void)footerBeginRefreshing {
    
    //如果正在刷新,直接返回
    if (self.isFooterRefreshing) return;

//    if (self.isHeaderRefreshing) return;
    
    self.footerRefreshing = YES;
    self.footerLabel.text = @"正在加载数据";
    self.footerLabel.backgroundColor = [UIColor blueColor];
    
    //发送请求数据给服务器,上拉家族更多数据
    [self loadMoreTopics];
    
}

/**>>>>>>>>>>>>>>>>>>>>>尾部结束刷新>>>>>>>>>>>>>>>>>>>>>>>*/

- (void)footerEndRefreshing {
    self.footerRefreshing = NO;
    self.footerLabel.text = @"上拉可以加载更多";
    self.footerLabel.backgroundColor = [UIColor redColor];
}

@end
