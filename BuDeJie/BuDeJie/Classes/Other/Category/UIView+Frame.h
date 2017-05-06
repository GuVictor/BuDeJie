//
//  UIView+Frame.h
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/12.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 gwd_viewFromXib
 写分类:避免跟其他开发者产生冲突,加前缀
 // 在分类中 @property 只会生成get, set方法,并不会生成下划线的成员属性
 */

@interface UIView (Frame)

/** view的frame中元素 */
@property CGFloat gwd_width;
@property CGFloat gwd_height;
@property CGFloat gwd_x;
@property CGFloat gwd_y;

/** 中心点 */
@property CGFloat gwd_centerX;
@property CGFloat gwd_centerY;

/** 通过xib加载View */
+ (instancetype)gwd_viewFromXib;
@end
