//
//  UIImageView+Download.h
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/29.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Download)
- (void)gwd_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholder:(UIImage *)placeholder;

- (void)gwd_setHeader:(NSString *)headerUrl;


@end
