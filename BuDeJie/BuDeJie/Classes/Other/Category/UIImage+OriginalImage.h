//
//  UIImage+OriginalImage.h
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/10.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OriginalImage)

/** 返回一张没有渲染的原始图片 */
+ (UIImage *)imageOriginalWithName:(NSString *)imageName;
@end
