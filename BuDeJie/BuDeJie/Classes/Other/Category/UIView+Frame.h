//
//  UIView+Frame.h
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/12.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 
 写分类:避免跟其他开发者产生冲突,加前缀
 
 */

@interface UIView (Frame)

@property CGFloat gwd_width;
@property CGFloat gwd_height;
@property CGFloat gwd_x;
@property CGFloat gwd_y;

@property CGFloat gwd_centerX;
@property CGFloat gwd_centerY;

+ (instancetype)gwd_viewFromXib;
@end
