//
//  GWDAllTableViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/18.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDAllTableViewController.h"

@interface GWDAllTableViewController ()

/** 模拟数据量 */
@property (assign, nonatomic) NSInteger  dataCount;

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




@end

@implementation GWDAllTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一开始给些数据
    self.dataCount = 10;
    
    self.view.backgroundColor = GWDRandomColor;
    self.tableView.contentInset = UIEdgeInsetsMake(GWDNavMaxY + GWDTitlesViewH , 0, GWDTabBarH, 0);
    
    //设置指示器的偏移量
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    //添加监听器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:GWDTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:GWDTitleButtonDidRepeatClickNotification object:nil];
    
    //设置刷新view(包括下拉刷新，和上拉刷新)
    [self setupRefresh];
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
    
    NSLog(@"%s刷新数据, line = %d", __FUNCTION__, __LINE__);
    
}

#pragma mark - 监听标题按钮的重复点击
- (void)titleButtonDidRepeatClick {
    //因为按钮重复点击的事情和精华按钮重复点击一样
    [self tabBarButtonDidRepeatClick];
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //在这个方法监听有没有数据，没有就隐藏footView
    self.footer.hidden = (self.dataCount == 0);
    
    return self.dataCount;
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
    
    //当scrollView的偏移量y值 >= ofsetY是, 代表footer意见完全出现
    CGFloat ofsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.gwd_height;
    
    if (self.tableView.contentOffset.y >= ofsetY) {
        //进入刷新状态
        self.footerRefreshing = YES;
        self.footerLabel.text = @"正在加载数据";
        self.footerLabel.backgroundColor = [UIColor blueColor];
        
        NSLog(@"%s, line = %d发送请求给服务器 - 加载更多数据", __FUNCTION__, __LINE__);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //服务器请求返回了
            self.dataCount += 5;
            [self.tableView reloadData];
            
            //结束刷新
            
            self.footerRefreshing = NO;
            self.footerLabel.text = @"上拉可以加载更多";
            self.footerLabel.backgroundColor = [UIColor redColor];
        });
        
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
        self.headerLabel.text = @"正在刷新数据...";
        self.headerLabel.backgroundColor = [UIColor blueColor];
        self.headerRefreshing = YES;
        
        //增加内边距
        [UIView animateWithDuration:0.25 animations:^{
            UIEdgeInsets inset = self.tableView.contentInset;
            inset.top += self.header.gwd_height;//增加的高度
            
            self.tableView.contentInset = inset;
        }];
        
        GWDLog(@"发送请求给服务器，下拉刷新数据");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.dataCount = 20;
            [self.tableView reloadData];
            
            //结束刷新
            self.headerRefreshing = NO;
            //减少内边距
            [UIView animateWithDuration:0.25 animations:^{
                UIEdgeInsets inset = self.tableView.contentInset;
                inset.top -= self.header.gwd_height;
                
                self.tableView.contentInset = inset;//还原内边距
            }];
        });
        
        
        
        
    }
    
    
    
}

@end
