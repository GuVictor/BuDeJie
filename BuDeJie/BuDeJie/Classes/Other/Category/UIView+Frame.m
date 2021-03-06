//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/12.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "UIView+Frame.h"

/*
    写分类：避免跟其他开发者产生冲突，加前缀
 */

@implementation UIView (Frame)

- (void)setGwd_height:(CGFloat)gwd_height {
    CGRect rect = self.frame;
    rect.size.height = gwd_height;
    self.frame = rect;
}

- (CGFloat)gwd_height {
    return self.frame.size.height;
}

- (void)setGwd_width:(CGFloat)gwd_width {
    CGRect rect = self.frame;
    rect.size.width = gwd_width;
    self.frame = rect;
}

- (CGFloat)gwd_width {
    return self.frame.size.width;
}

- (void)setGwd_x:(CGFloat)gwd_x {
    CGRect rect = self.frame;
    rect.origin.x = gwd_x;
    self.frame = rect;
}

- (CGFloat)gwd_x {
    return self.frame.origin.x;
}

- (void)setGwd_y:(CGFloat)gwd_y {
    CGRect rect = self.frame;
    rect.origin.y = gwd_y;
    self.frame = rect;
}

- (CGFloat)gwd_y {
    return self.frame.origin.y;
}

- (void)setGwd_centerX:(CGFloat)gwd_centerX {
    CGPoint center = self.center;
    center.x = gwd_centerX;
    self.center = center;
}

- (CGFloat)gwd_centerX {
    return self.center.x;
}

- (void)setGwd_centerY:(CGFloat)gwd_centerY {
    CGPoint center = self.center;
    center.y = gwd_centerY;
    self.center  = center;
}

- (CGFloat)gwd_centerY {
    return self.center.y;
}


#pragma mark - 通过xib加载View
/*使用实例：- (GWDPictureView *)pictureView {
 if (!_pictureView) {
 GWDPictureView *pictureView = [GWDPictureView gwd_viewFromXib];
 [self.contentView addSubview:pictureView];
 _pictureView = pictureView;
 }
 
 return _pictureView;
 }*/
+ (instancetype)gwd_viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:0].firstObject;
}

@end
