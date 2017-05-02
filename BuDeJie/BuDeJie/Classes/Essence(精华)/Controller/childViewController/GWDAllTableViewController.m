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

/** 当前最后一条帖子数据的描述信息，专门用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;

/** 所有的帖子数据 */
@property (nonatomic, strong) NSMutableArray<GWDTopic *> *topics;




/** 上拉刷新控件 */
@property (nonatomic, weak) UIView *footer;
/** 上拉刷新控件里面的文字 */
@property (nonatomic, weak) UILabel *footerLabel;
/** 上拉刷新控件是否正在刷新 */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;


/** 下拉刷新控件 */
@property (nonatomic, weak) UIView *header;
/** 下拉刷新控件里面的文字 */
@property (nonatomic, weak) UILabel *headerLabel;
/** 下拉刷新控件是否正在刷新 */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;

/** 请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

// 有了方法声明，点语法才会有智能提示
- (GWDTopicType)type;
@end

@implementation GWDAllTableViewController

/* cell的重用标识 */
static NSString * const GWDTopicCellId = @"GWDTopicCellId";


#pragma mark - view的声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor = GWDGrayColor(206);
    
    //设置一开始的tableView的内边距（64 + 35）
    self.tableView.contentInset = UIEdgeInsetsMake(GWDNavMaxY + GWDTitlesViewH, 0, GWDTabBarH, 0);
    //设置tableView滚动条偏移量，因为tableView设置了内边距，导致滚动条开始的位置不同，所以设置一下
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([GWDTopicCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:GWDTopicCellId];
    
    //监听按钮的重复点击，刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:GWDTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:GWDTitleButtonDidRepeatClickNotification object:nil];
    
    //tableVIew顶部和底部的刷新设置
    [self setupRefresh];
}

#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager {
    //用于处理不能同时进行上拉和下拉刷新
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


#pragma mark - 设置tableFooterView为刷新更多数据
- (void)setupRefresh {
    // 广告条(tableView的headVIew)
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 0, 30);
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.text = @"广告";
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
    
    // header(tableView的子控件)
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, - 50, self.tableView.gwd_width, 50);
    self.header = header;
    [self.tableView addSubview:header];
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = header.bounds;
    headerLabel.backgroundColor = [UIColor redColor];
    headerLabel.text = @"下拉可以刷新";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:headerLabel];
    self.headerLabel = headerLabel;
    
    // 让header自动进入刷新
    [self headerBeginRefreshing];
    
    // footer
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, self.tableView.gwd_width, 35);
    self.footer = footer;
    
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.frame = footer.bounds;
    footerLabel.backgroundColor = [UIColor redColor];
    footerLabel.text = @"上拉可以加载更多";
    footerLabel.textColor = [UIColor whiteColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:footerLabel];
    self.footerLabel = footerLabel;
    
    self.tableView.tableFooterView = footer;
}

#pragma mark - 移除监听器
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听tabBarButton重复点击
/**
 *  监听tabBarButton重复点击
 */
- (void)tabBarButtonDidRepeatClick {
    // 重复点击的不是精华按钮
    if (self.view.window == nil) return;
    
    // 显示在正中间的不是AllViewController
    if (self.tableView.scrollsToTop == NO) return;
    
    // 进入下拉刷新
    [self headerBeginRefreshing];
}
#pragma mark - 监听标题按钮的重复点击
/**
 *  监听titleButton重复点击
 */
- (void)titleButtonDidRepeatClick {
    [self tabBarButtonDidRepeatClick];
}

#pragma mark - 数据处理
- (GWDTopicType)type {
    return GWDTopicTypePicture;
}

/**
 *  发送请求给服务器，下拉刷新数据
 */
- (void)loadNewTopics {
    // 1.取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    
    // 3.发送请求
    [self.manager GET:GWDCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        GWDAFNWriteToPlist(new_topics)
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数据
        self.topics = [GWDTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self headerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务导致的error，其他网络问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        
        // 结束刷新
        [self headerEndRefreshing];
    }];
}

/**
 *  发送请求给服务器，上拉加载更多数据
 */
- (void)loadMoreTopics {
    // 1.取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"maxtime"] = self.maxtime;
    
    // 3.发送请求
    [self.manager GET:GWDCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数据
        NSArray *moreTopics = [GWDTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 累加到旧数组的后面
        [self.topics addObjectsFromArray:moreTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self footerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务导致的error，其他网络问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        
        // 结束刷新
        [self footerEndRefreshing];
    }];
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 根据数据量显示或者隐藏footer
    self.footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWDTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:GWDTopicCellId];
    
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

/**
 *  用户松开scrollView时调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {//改变内边距会影响contentOffSet
    CGFloat offsetY = - (self.tableView.contentInset.top + self.header.gwd_height);
    if (self.tableView.contentOffset.y <= offsetY) {//改变内边距会影响contentOffSet
        //如果正在下拉刷新，直接返回

        [self headerBeginRefreshing];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 处理header
    [self dealHeader];
    
    // 处理footer
    [self dealFooter];
}

/**
 *  处理footer
 */
- (void)dealFooter {
    // 还没有任何内容的时候，不需要判断
    if (self.tableView.contentSize.height == 0) return;
    
    // 当scrollView的偏移量y值 >= offsetY时，代表footer已经完全出现
    CGFloat ofsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.gwd_height;
    if (self.tableView.contentOffset.y >= ofsetY && self.tableView.contentOffset.y > -(self.tableView.contentInset.top)) {
        // footer完全出现，并且是往上拖拽
        [self footerBeginRefreshing];
    }
}


/**
 *  处理header
 */
- (void)dealHeader {
    //如果正在下拉刷新,直接返回
    if (self.isHeaderRefreshing) return;
    
    // 当scrollView的偏移量y值 <= offsetY时，代表header已经完全出现
    CGFloat offsetY = - (self.tableView.contentInset.top + self.header.gwd_height);
    if (self.tableView.contentOffset.y <= offsetY) {
        // header已经完全出现
        self.headerLabel.text = @"松开立即刷新";
        self.headerLabel.backgroundColor = [UIColor grayColor];
    } else {
        self.headerLabel.text = @"下拉可以刷新";
        self.headerLabel.backgroundColor = [UIColor redColor];
    }
}


#pragma mark - 头部刷新处理
/**>>>>>>>>>>>>>>>>>>>>>头部开始刷新>>>>>>>>>>>>>>>>>>>>>>>*/
- (void)headerBeginRefreshing {
    //如果正在下拉刷新，直接返回
    if (self.isHeaderRefreshing) return;
    
    //进入下拉刷新状态
    self.headerLabel.text = @"正在刷新数据...";
    self.headerLabel.backgroundColor = [UIColor blueColor];
    self.headerRefreshing = YES;
    //增加内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top += self.header.gwd_height;//增加的高度
        self.tableView.contentInset = inset;
        
        //修改偏移量
#warning (self.tableView.contentInset.top)

        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, - inset.top);
    }];
    
    // 发送请求给服务器，下拉刷新数据
    [self loadNewTopics];
}

/**>>>>>>>>>>>>>>>>>>>>>头部结束刷新>>>>>>>>>>>>>>>>>>>>>>>*/


- (void)headerEndRefreshing {
    self.headerRefreshing = NO;
    // 减小内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top -= self.header.gwd_height;
        
        self.tableView.contentInset = inset;;//还原内边距
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
    
    // 发送请求数据给服务器,上拉家族更多数据
    [self loadMoreTopics];
}
/**>>>>>>>>>>>>>>>>>>>>>尾部结束刷新>>>>>>>>>>>>>>>>>>>>>>>*/

- (void)footerEndRefreshing {
    self.footerRefreshing = NO;
    self.footerLabel.text = @"上拉可以加载更多";
    self.footerLabel.backgroundColor = [UIColor redColor];
}

@end
