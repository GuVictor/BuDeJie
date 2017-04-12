//
//  UIBarButtonItem+Item.h
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/12.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)


+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)traget action:(SEL)action;

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image selLimage:(UIImage *)selImage target:(id)traget action:(SEL)action;
@end
