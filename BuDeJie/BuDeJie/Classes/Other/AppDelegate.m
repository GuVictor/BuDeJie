//
//  AppDelegate.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/10.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "AppDelegate.h"
#import "GWDTabBarController.h"
#import "GWDDdViewController.h"
#import <AFNetworking.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

/*
 优先级:LaunchScreen > LaunchImage
 在xcode配置了,不起作用 1.清空xcode缓存(common + shift +k) 2.直接删掉程序 重新运行
 如果是通过LaunchImage设置启动界面,那么屏幕的可视范围由图片决定
 注意:如果使用LaunchImage,必须让你的美工提供各种尺寸的启动图片
 
 LaunchScreen:Xcode6开始才有
 LaunchScreen好处:1.自动识别当前真机或者模拟器的尺寸 2.只要让美工提供一个可拉伸图片
 3.展示更多东西 分析：为什么其他图片可以显示，我的不显示
 
 LaunchScreen底层实现:把LaunchScreen截屏,生成一张图片.作为启动界面
 
 */


//在这里确定项目的结构：使用主流架构(UITabBarController + 导航控制器)
//->项目的开发方式 使用纯代码

//自定义类：1.可以管理自己的业务
//分装：谁的事情谁管理 = 方便以后器维护代码


//程序启动的时候就会调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //设置跟控制器
//    GWDTabBarController *tabBarVc = [[GWDTabBarController alloc] init];
//    self.window.rootViewController = tabBarVc;
    //进入广告界面
    GWDDdViewController *adVC = [[GWDDdViewController alloc] init];
    self.window.rootViewController = adVC;
    
    //显示窗口
    [self.window makeKeyAndVisible];
    
    //开始监听网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 5.每次启动程序，都清除过期的图片
    //    [[SDImageCache sharedImageCache] cleanDisk];

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
