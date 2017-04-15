//
//  GWDSubTagTableVC.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/14.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDSubTagTableVC.h"
#import "GWDSubTagTableViewCell.h"


#import "GWDSubTagItem.h"
#import <AFNetworking/AFNetworking.h>
#import  <MJExtension.h>
#import <SVProgressHUD.h>
@interface GWDSubTagTableVC ()
@property (strong, nonatomic) NSArray *subTags;

@property (weak, nonatomic) AFHTTPSessionManager *mgr;

@end

@implementation GWDSubTagTableVC
//接口文档：请求URL(基本URL + 请求参数)请求方式
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题
    self.title = @"推荐标签";
    
    //展示标签数据 -> 请求数据(接口文档) -> 解析数据(写成Plist)
    //先写必填的() -> 返回有用的数据(image_list,sub_number,theme_name) -> 设计模型 -> 模型转换 -> 展示数据
    
    //请求数据
    [self loadData];
    
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GWDSubTagTableViewCell" bundle:nil]  forCellReuseIdentifier:NSStringFromClass([self class])];
    
    //处理cell的分割线，1.自定义分割线 2.系统属性（ios8后）
    //3.万能  了解tableView底层实现了解 1.取消系统自带分割线 2.把tableView背景色设置为分割线的背景色 3.重写setFrame
    
    //清空tableView分割线内边距 清空cell的约束边距
//    self.tableView.separatorInset = UIEdgeInsetsZero;//先打印一下左边16，ios8添加了边缘约束， cell的边缘
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//取消系统分割线
    
    self.tableView.backgroundColor = GWDColor(220, 220, 221);//设置背景颜色为灰色，然后设置frame，设置cell的高度-1
    
    //提示用户当前正在加载数据 SVpro
    [SVProgressHUD showWithStatus:@"正在加载ing..."];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //销毁指示器
    [SVProgressHUD dismiss];
    
    //取消之前的请求
    [_mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    
}

#pragma mark - 请求数据
- (void)loadData {
    //1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    _mgr = mgr;
    
    //2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"]= @"sub";
    parameters[@"c"] = @"topic";
    //3.发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //销毁指示器
        [SVProgressHUD dismiss];

        
//        [responseObject writeToFile:@"/Users/guweidong/Desktop/ad/tag.plist" atomically:YES];
        _subTags = [GWDSubTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        //刷新表格
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
        //销毁指示器
        [SVProgressHUD dismiss];

    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.subTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWDSubTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    GWDSubTagItem *item = self.subTags[indexPath.row];
    cell.item = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
@end
