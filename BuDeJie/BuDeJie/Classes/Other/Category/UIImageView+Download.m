//
//  UIImageView+Download.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/29.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "UIImageView+Download.h"
#import <AFNetworkReachabilityManager.h>
#import <UIImageView+WebCache.h>
@implementation UIImageView (Download)

//    [[SDWebImageManager sharedManager]setCacheKeyFilter:^(NSURL *url) {
//        // 所有缓存图片的key后面都有个-xmg后缀
//        return [NSString stringWithFormat:@"%@-xmg", url.absoluteString];
//    }];

#pragma mark - 根据网络状态下载图片，原图，缩略图
- (void)gwd_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholder:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    
    
    //根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    //获得原图片（SDWebImage的图片缓存是用图片的url字符串作为key）
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originImageURL];
    if (originImage) {//原图已经被下载过
//        self.image = originImage;
        [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completedBlock];
        //调用图片处理的bolck
        completedBlock(originImage, nil, 0, [NSURL URLWithString:originImageURL]);
        
    }else { //原图没有下载过
        if (mgr.isReachableViaWiFi) {
            [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completedBlock];
        }else if (mgr.isReachableViaWWAN) {
#warning downloadOriginImageWhen3GOr4G配置项的值需要从沙盒里面获取
            //3G\4G网络下的时候下载原图
            BOOL downloadOriginImageWhen3GOr4G = YES;
            if (downloadOriginImageWhen3GOr4G) {//3G/4G
                [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completedBlock];
            } else {//2G网络
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder completed:completedBlock];
            }
        } else { //没有可以用的网络
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageURL];
            if (thumbnailImage) { //如果缩略图已经被下过
//                self.image = thumbnailImage;
//                completedBlock(thumbnailImage, nil, 0 ,[NSURL URLWithString:thumbnailImageURL]);
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder completed:completedBlock];
            } else { //没有下过任何图片
                //占位图片
//                self.image = placeholder;
                [self sd_setImageWithURL:nil placeholderImage:placeholder completed:completedBlock];
            }
            
        }
        
    }
}


#pragma mark - 头像图片下载，下载完成的图片和占位图片圆角处理
- (void)gwd_setHeader:(NSString *)headerUrl {
    UIImage *placeholder = [UIImage gwd_circleImageNamed:@"defaultUserIcon"];
    [self sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //图片下载失败，直接返回，安装它的默认做法
        if (!image) return ;
        self.image = [image gwd_circleImage];
    }];
}
@end
