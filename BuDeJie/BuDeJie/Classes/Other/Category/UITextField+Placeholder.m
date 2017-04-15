//
//  UITextField+Placeholder.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/16.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "UITextField+Placeholder.h"

@implementation UITextField (Placeholder)

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    //设置占位文字颜色
    UILabel *placeHolderLabel = [self valueForKey:@"placeholderLabel"];
    placeHolderLabel.textColor = placeholderColor;
}

-(UIColor *)placeholderColor {
    return nil;
}
@end
