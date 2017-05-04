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
#import <Photos/Photos.h>
@interface GWDSeeBigPictureViewController ()<UIScrollViewDelegate>
/** 保存图片按钮 */
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
/** scrollView */
@property (weak, nonatomic) UIScrollView *scrollVIew;
/** imageView */
@property (weak, nonatomic) UIImageView *imageView;

/** 当前APP对应的自定义相册 */
- (PHAssetCollection *)createdCollection;
/** 返回刚才保存到 相机胶卷 的图片 */
- (PHFetchResult<PHAsset *> *)createdAssets;
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

#pragma mark - 获得当前APP对应的自定义相册
- (PHAssetCollection *)createdCollection {
    //获得软件名字
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    
    //获取所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    //查找当前APP对应自定义相册
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    
    /** 当前APP对应的自定义相册没有被创建过 */
    //创建一个[自定义相册]
    NSError *error = nil;
    __block NSString *createdCollectionID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
//        [SVProgressHUD showErrorWithStatus:@"创建失败"];
        return nil;
    }
    
    //根据唯一标识获得刚才创建的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionID] options:nil].firstObject;
}

#pragma mark - 获取相片
- (PHFetchResult<PHAsset *> *)createdAssets {
    NSError *error = nil;
    __block NSString *assetID = nil;
    
    //保存图片到 相机胶卷
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    if (error) return nil;
    
    //获取刚才保存的图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}

#pragma mark - 保存图片到自定义相册
- (void)saveImageIntoAlbum {
    //获得相片
    PHFetchResult<PHAsset *> * createAssets = self.createdAssets;
    
    if (createAssets == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
        return;
    }
    
    //获得相册
    PHAssetCollection *createdCollection = self.createdCollection;
    if (createdCollection == nil) {
        [SVProgressHUD showErrorWithStatus:@"创建或者获取相册失败！"];
        return;
    }
    
    //添加刚才保存的图片到 自定义相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    //最后的判断
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
    }else {
        [SVProgressHUD showErrorWithStatus:@"保存图片成功"];
    }
}

#pragma mark - 按钮的点击
- (IBAction)savePucture:(UIButton *)sender {
    //拿出当前的授权状态
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    
    //请求\检查访问权限：
    //如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后，才会调用block
    //如果之前已经做出选择，会直接执行block
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        /*
         PHAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
         PHAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
         // The user cannot change this application’s status, possibly due to active restrictions
         //   such as parental controls being in place.
         PHAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.
         PHAuthorizationStatusAuthorized
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (status == PHAuthorizationStatusDenied) {//用户拒绝当前APP访问相册
                if (oldStatus != PHAuthorizationStatusNotDetermined) {//未决定
                    NSLog(@"提醒用户打开开关");
                }
            } else if (status == PHAuthorizationStatusAuthorized) {//用户允许当前app访问相册
                [self saveImageIntoAlbum];
            } else if (status == PHAuthorizationStatusRestricted) {//无法访问相册
                [SVProgressHUD showErrorWithStatus:@"因为系统原因,无法访问相册！"];
                
            }
        });
    }];
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


//UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//}
//
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    if (error) {
//        [SVProgressHUD showErrorWithStatus:@"保存失败"];
//    } else {
//        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
//    }

@end
