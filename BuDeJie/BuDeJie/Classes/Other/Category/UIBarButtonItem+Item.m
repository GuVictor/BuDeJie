//
//  UIBarButtonItem+Item.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/12.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)

#pragma mark - 导航条按钮高亮模式
/*  使用实例  左边按钮
 self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];*/
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];//解决点击按钮其他位置会有反应
    [containView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:containView];

}
/*UIBarButtonItem *nightBtnItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selLimage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];*/
#pragma mark - 导航条按钮的选中模式
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image selLimage:(UIImage *)selImage target:(id)traget action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn sizeToFit];
    [btn addTarget:traget action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
    
}

/*使用实例
  viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"];
 */
#pragma mark - 导航条的返回返回按钮，自定义btn
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)traget action:(SEL)action title:(NSString *)title {
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:title forState:UIControlStateNormal];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn setImage:highImage forState:UIControlStateHighlighted];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backBtn sizeToFit];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backBtn addTarget:traget action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
@end
