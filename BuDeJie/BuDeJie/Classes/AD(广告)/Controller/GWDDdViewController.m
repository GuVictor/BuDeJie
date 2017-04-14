//
//  GWDDdViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/13.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDDdViewController.h"
#import "GWDAdItem.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
/*
 1.广告业务逻辑
 2.占位视图思想：有个控件不能确定尺寸，但是层次就给已经确定，就可以使用占位视图
 3.屏幕适配，通过屏幕goad判断
 */

#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface GWDDdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UIView *adContainView;
@property (weak, nonatomic) UIImageView *adView;


@property (strong, nonatomic) GWDAdItem *adItem;

@end

@implementation GWDDdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置启动图片
    [self setupLaunchImage];
    //加载广告数据 => 拿到活数据 => 服务器 = > 查看接口文档 => 1.判断接口对不对 2.解析数据(w_picurl,ori_curl:跳转到广告界面,w,h) => 请求数据(AFN)
    [self loadAdData];
}

#pragma mark - 懒加载
- (UIImageView *)adView {
    if (!_adView) {
        UIImageView *imageV = [[UIImageView alloc] init];
        
        [self.adContainView addSubview:imageV];
        _adView = imageV;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageV addGestureRecognizer:tap];
        
        imageV.userInteractionEnabled = YES;
    
    }
    
    return _adView;
}
#pragma mark - 加载广告数据
- (void)loadAdData {
    //1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code2;
    //3.发送请求
    [mgr GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求数据 => 解析数据(写成plist文件) => 设计模型 => 字典转模型 => 展示数据
        
        //获取字典
//        NSDictionary *adDict = [responseObject]

//        [responseObject writeToFile:@"/Users/guweidong/Desktop/ad/ad.plist" options:0 error:nil];
//        [responseObject writeToFile:@"/Users/guweidong/Desktop/ad/ad.plist" atomically:YES];
    
        NSDictionary *adDict = [responseObject[@"ad"] lastObject];
        
        //字典转模型
        _adItem = [GWDAdItem mj_objectWithKeyValues:adDict];
        NSLog(@"%@", _adItem.w_picurl);
        
        //创建imageView展示图片
        CGFloat h = GWDScreenW / _adItem.w * _adItem.h;
        self.adView.frame = CGRectMake(0, 0, GWDScreenW, h);
        [self.adView sd_setImageWithURL:[NSURL URLWithString:_adItem.w_picurl]];
        
//        NSLog(@"%@" , self.adView);
        //加载广告页面
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)tap:(UITapGestureRecognizer *)pan {
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    
    //界面跳转 => safari
    NSURL *url = [NSURL URLWithString:_adItem.ori_curl];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url options:nil completionHandler:nil];
    }
}

#pragma mark - 设置启动图片
- (void)setupLaunchImage {
    // 6p:LaunchImage-800-Portrait-736h@3x.png
    // 6:LaunchImage-800-667h@2x.png
    // 5:LaunchImage-568h@2x.png
    // 4s:LaunchImage@2x.png

    if (iphone6P) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }else if (iphone6) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h@2x"];
    }else if (iphone5) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-568h"];
    }else if (iphone4) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-700"];
    }
}

@end
