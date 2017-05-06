//
//  UITextField+Placeholder.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/16.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "UITextField+Placeholder.h"
#import <objc/message.h>

@implementation UITextField (Placeholder)
/*
 //分析:为什么先设置占位位置颜色,就没有效果 => 占位文字label拿不到
 //1.保存起来
 //设置占位文字颜色
 //    _textFiled.placeholderColor = [UIColor blueColor];
 //设置占位位置:每次设置占位文字的后，再拿到之前保存占位文字颜色，重新设置
 //    [_textFiled setGwd_PlaceHoder:@"hello"];
 //    _textFiled.placeholder = @"hello";

 */
#pragma mark - 交换方法
+ (void)load {
    Method setPlaceHolderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setGwd_PlaceHolderMethod = class_getInstanceMethod(self, @selector(setGwd_PlaceHoder:));
    
    method_exchangeImplementations(setPlaceHolderMethod, setGwd_PlaceHolderMethod);
}


- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    //设置占位文字颜色
    //先把设置的颜色(因为那是还没有值)，用属性保存起来
    
    //给成员属性赋值 runtime给系统的类添加成员属性
    //添加成员属性
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //获取占位文字label控件
    UILabel *placeHolderLabel = [self valueForKey:@"placeholderLabel"];
    
    //设置占位文字颜色
    placeHolderLabel.textColor = placeholderColor;
}

//给取 自己给的属性的值
-(UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, @"placeholderColor");
}

- (void)setGwd_PlaceHoder:(NSString *)placeHoder {
//    [self setPlaceholder:placeHoder];调换了要改
    [self setGwd_PlaceHoder:placeHoder];
    
    self.placeholderColor = self.placeholderColor;
}


@end
