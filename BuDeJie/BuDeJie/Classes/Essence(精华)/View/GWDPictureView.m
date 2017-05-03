//
//  GWDPictureView.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/27.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDPictureView.h"
#import "GWDTopic.h"
#import "GWDSeeBigPictureViewController.h"
@interface GWDPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;

@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;

@end

@implementation GWDPictureView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    //控件按钮内部子控件之间的间距
    _seeBigPictureButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _seeBigPictureButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    //给imageVIew添加手势
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
    
}

#pragma mark - 点击图片显示大图
- (void)seeBigPicture {
    GWDSeeBigPictureViewController *vc = [[GWDSeeBigPictureViewController alloc] init];
    vc.topic = _topic;
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
}

- (void)setTopic:(GWDTopic *)topic {
    _topic = topic;
    
    
    // 设置图片
    self.placeholderView.hidden = NO;
    [self.imageView gwd_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        
        self.placeholderView.hidden = YES;
    }];
    
    // gif
    self.gifView.hidden = !topic.is_gif;
    
    // 点击查看大图
    if (topic.isBigPicture) { // 超长图
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
        
        // 处理超长图片的大小
        if (self.imageView.image) {
            CGFloat imageW = topic.middleFrame.size.width;
            CGFloat imageH = imageW * topic.height / topic.width;
            
            // 开启上下文
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            // 绘制图片到上下文中
            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭上下文
            UIGraphicsEndImageContext();
        }
    } else {//普通图片
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
        
    }

}

//    [UIApplication sharedApplication].keyWindow.rootViewController;
//判断后缀名
// http://ww2.sinaimg.cn/bmiddle/005yUFpDjw1f297c6vgzig306y04rnpd.GIF
//    if ([topic.image1.lowercaseString hasSuffix:@"gif"]) {
//    if ([topic.image1.pathExtension.lowercaseString isEqualToString:@"gif"]) {
//        self.gifView.hidden = NO;
//    } else {
//        self.gifView.hidden = YES;
//    }



@end
