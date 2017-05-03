//
//  GWDSeeBigPictureViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/5/2.
//  Copyright © 2017年 victorgu. All rights reserved.
//

/*
 一种很常见的开发思路
 1.在viewDidLoad方法中添加初始化子控件
 2.在viewDidLayoutSubviews方法中布局子控件（设置子控件的位置和尺寸）
 
 另一种常见的开发思路
 1.控件弄成懒加载
 2.在viewDidLayoutSubviews方法中布局子控件（设置子控件的位置和尺寸）
 */

#import "GWDSeeBigPictureViewController.h"
#import "GWDTopic.h"
#import <SVProgressHUD.h>

@interface GWDSeeBigPictureViewController ()<UIScrollViewDelegate>
/** 保存图片按钮 */
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
/** scrollView */
@property (weak, nonatomic) UIScrollView *scrollVIew;
/** imageView */
@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation GWDSeeBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)]];
    //注意不能挡住了按钮
    [self.view insertSubview:scrollView atIndex:0];
    self.scrollVIew = scrollView;
    
    //imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_topic.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return ;
        
        self.saveButton.enabled = YES;
    }];
    
    imageView.gwd_width = scrollView.gwd_width;
    imageView.gwd_height = imageView.gwd_width * _topic.height / _topic.width;
    
    imageView.gwd_x = 0;
    
    if (imageView.gwd_height > GWDScreenH) {
        //超长图片
        imageView.gwd_y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.gwd_height);
    } else {
        //一般图
        imageView.gwd_centerY = scrollView.gwd_height * 0.5;
    }
    
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    //图片缩放
    CGFloat maxScale = self.topic.width / imageView.gwd_width;
    if (maxScale > 1) {
        //缩放比例
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
    }
}

#pragma mark - uiScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView   {
    return self.imageView;//scrollView的子控件
}

#pragma mark - 按钮的点击
- (IBAction)savePucture:(UIButton *)sender {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
 一、保存图片到【自定义相册】
 1.保存图片到【相机胶卷】
 1> C语言函数UIImageWriteToSavedPhotosAlbum
 2> AssetsLibrary框架
 3> Photos框架
 
 2.拥有一个【自定义相册】
 1> AssetsLibrary框架
 2> Photos框架
 
 3.添加刚才保存的图片到【自定义相册】
 1> AssetsLibrary框架
 2> Photos框架
 */

/*
 [UIView animateWithDuration:2.0 animations:^{
 self.view.frame = CGRectMake(0, 0, 100, 100);
 } completion:^(BOOL finished) {
 
 }];
 
 [UIView beginAnimations:nil context:nil];
 [UIView setAnimationDuration:2.0];
 [UIView setAnimationDelegate:self];
 [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
 self.view.frame = CGRectMake(0, 0, 100, 100);
 [UIView commitAnimations];
 
 - (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
 {
 
 }*/

//  UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(a:b:c:), nil);
//- (void)a:(UIImage *)image b:(NSError *)error c:(void *)contextInfo
//{
//    if (error) {
//        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
//    } else {
//        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
//    }
//}

//- (void)done
//{
//    XMGFunc
//}

/*
 错误信息：-[NSInvocation setArgument:atIndex:]: index (2) out of bounds [-1, 1]
 错误解释：参数越界错误，方法的参数个数和实际传递的参数个数不一致
 */

//- (UIScrollView *)scrollView
//{
//    if (!_scrollView) {
//        UIScrollView *scrollView = [[UIScrollView alloc] init];
//        scrollView.backgroundColor = [UIColor redColor];
//        [self.view insertSubview:scrollView atIndex:0];
//        _scrollView = scrollView;
//    }
//    return _scrollView;
//}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//
//    self.scrollView.frame = self.view.bounds;
//}



@end
