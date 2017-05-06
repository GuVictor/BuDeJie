//
//  UIImage+Image.h
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/27.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
/** 没有渲染的图片 */
+ (instancetype)imageOriginalWithName:(NSString *)imageName;
/** 对已有的图片圆形图片处理 */
- (instancetype)gwd_circleImage;
/** 生成一张圆形图片 */
+ (instancetype)gwd_circleImageNamed:(NSString *)name;
@end
