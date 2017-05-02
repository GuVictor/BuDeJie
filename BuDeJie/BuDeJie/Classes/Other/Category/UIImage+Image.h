//
//  UIImage+Image.h
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/27.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
+ (instancetype)imageOriginalWithName:(NSString *)imageName;

- (instancetype)gwd_circleImage;

+ (instancetype)gwd_circleImageNamed:(NSString *)name;
@end