//
//  GWDNavgationController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/10.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDNavgationController.h"

@interface GWDNavgationController ()<UIGestureRecognizerDelegate>

@end



@implementation GWDNavgationController

+ (void)load {
    //只要是通过模型设置，都是通过富文本设置
    //设置导航条标题 => UINavigationBar
    
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    NSMutableDictionary *attrsDict = [NSMutableDictionary dictionary];
    attrsDict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navBar setTitleTextAttributes:attrsDict];
    
    //设置导航条背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    
}

// <_UINavigationInteractiveTransition: 0x7f9c948302a0>:手势代理

/*
 UIPanGestureRecognizer
 
 UIScreenEdgePanGestureRecognizer:导航滑动手势
 target=<_UINavigationInteractiveTransition 0x7fdc4a740440>)
 action=handleNavigationTransition:
 
 
 <UIScreenEdgePanGestureRecognizer: 0x7fdc4a740120; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7fdc4a73e690>; target= <(action=handleNavigationTransition:, >>
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //清空代理，但有bug，在跟控制滑动会卡死；
//    self.interactivePopGestureRecognizer.delegate = nil;
    
    //控制手势在什么时候触发，只有非根控制器才需要触发手势
//    self.interactivePopGestureRecognizer.delegate = self;
    
    //全屏滑动手势
    //self.interactivePopGestureRecognizer.delegate从他的类型看，和一般设置手势的的代理推断
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    
    //控制手势什么时候触发，只有非根控制器才触发手势
    pan.delegate = self;
    
    self.interactivePopGestureRecognizer.enabled = NO;
    
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) { //非根控制器
        
        //默认返回按钮有滑动返回，我们覆盖了 恢复滑动返回功能 -> 分析：把系统的返回按钮覆盖 -> 1.手势失效（看导航控制器属性，有一个手势属性）(1.手势被清空（覆盖系统按钮时打印手势是否存在，在）=> 2.(打印手势代理 有)可能手势代理做了一些事情，导致手势失效) 所有我们清空代理就有效
        
        //设置返回按钮，只有非根控制器
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"];
    }
    
    //正真的调整，不调用永远不会调转
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

//决定手势是否触发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.childViewControllers.count > 1;
}
@end
