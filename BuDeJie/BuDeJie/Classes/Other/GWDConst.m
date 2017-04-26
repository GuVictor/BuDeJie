//
//  GWDConst.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/19.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <UIKit/UIKit.h>

/** UITabBar的高度 */
CGFloat const GWDTabBarH = 49;

/** 导航栏的最大Y值 */
CGFloat const GWDNavMaxY = 64;

/** 标题栏的高度 */
CGFloat const GWDTitlesViewH = 35;

/** TabBarButton被重复点击的通知 */
NSString * const GWDTabBarButtonDidRepeatClickNotification = @"GWDTabBarButtonDidRepeatClickNotification";

/** 标题栏的标题按钮被重复点击的通知 */
NSString * const GWDTitleButtonDidRepeatClickNotification = @"GWDTitleButtonDidRepeatClickNotification";


/** 统一的一个请求路径 */
NSString * const GWDCommonURL = @"http://api.budejie.com/api/api_open.php";
