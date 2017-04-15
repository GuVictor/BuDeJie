//
//  GWDLoginTextField.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/16.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDLoginTextField.h"

@implementation GWDLoginTextField

/*
 1.先把要做的事写出来
 2. 就知道在哪里写
 3.写多少次，设置多少次
 
 一层层找color子类到父类
 */



/*
    1.文本框关闭变成白色
    2.文本框开始编辑的时候,占位文字颜色变成白色
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //监听文本框编辑： 1.代理  2.通知 3.target
    //代理：不要自己成为自己的代理，这样很好笑，因为自己不做的事情才给别人做
    
    //设置光标颜色为白色
    //一直找color在UIView中找到TintColor
    self.tintColor = [UIColor whiteColor];
    
    //开始编辑
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    //结束编辑
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    
    //设置占位文字颜色变成白色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
}

#pragma mark - 文本框开始编辑时调用
- (void)textBegin {
    
    //设置占位文字颜色变成白色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    
    
}

#pragma mark - 文本框结束编辑时调用
- (void)textEnd {
    //结束时应该还原
    //设置占位文字颜色变成白色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    
}





@end
