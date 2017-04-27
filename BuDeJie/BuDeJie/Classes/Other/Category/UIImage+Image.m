//
//  UIImage+Image.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/27.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)
#pragma mark - 没有被渲染的图片
+ (instancetype)imageOriginalWithName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark - 圆形图片
- (instancetype)gwd_circleImage {
    // 1.开启图形上下文
    // 比例因素:当前点与像素比例
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 2.描述裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置裁剪区域;
    [path addClip];
    // 4.画图片
    [self drawAtPoint:CGPointZero];
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)gwd_circleImageNamed:(NSString *)name {
    return [[self imageNamed:name] gwd_circleImage];
}
@end
