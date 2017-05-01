//
//  GWDSubTagTableViewCell.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/14.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDSubTagTableViewCell.h"
#import "GWDSubTagItem.h"
#import <UIImageView+WebCache.h>
#import "UIImage+Antialias.h"
@interface GWDSubTagTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *numView;

@end
@implementation GWDSubTagTableViewCell

#pragma mark - 从xib加载就会调用一次
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    /*
     头像变成圆角 1.设置头像圆角(也可以在xib通过添加字典)
               2.裁剪图片 (上下文)略
     
     处理数字
     */
    
    //只支持ios9，ios9才修复bug，帧数变低的问题
//    self.iconImageV.layer.cornerRadius = 30;
//    self.iconImageV.layer.masksToBounds = YES;
    
//    self.layoutMargins = UIEdgeInsetsZero;
    
    
}

- (void)setFrame:(CGRect)frame {
    
    
//    GWDLog(@"%@", NSStringFromCGRect(frame));
    frame.size.height -= 1;
    //才是真正去给cell赋值
    [super setFrame:frame];
}

#pragma mark - 设置数据
- (void)setItem:(GWDSubTagItem *)item {
    _item = item;
    
    //设置订阅名
    _nameView.text = item.theme_name;
    
    //订阅数字处理；判断下有没有>1000
    [self resolveNum];
    
    //设置圆形图片
    [_iconImageV gwd_setHeader:item.image_list];
//    [_iconImageV sd_setImageWithURL:[NSURL URLWithString:item.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        //1.开启上下文
//            //最后一个参数，是比例参数，6P 3X ， 6 2X ， 4s 1; 传0自动适配设备
//        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
//        //2.描述裁剪区域
//        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
//        
//        //3.设置裁剪区域
//        [path addClip];
//        //4.画图片
//        [image drawAtPoint:CGPointZero];
//        //5.取出图片
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        _iconImageV.image = [image imageAntialias];//抗锯齿
//        
//        //6.关闭上下文
//        UIGraphicsEndImageContext();
//    }  ];
}

#pragma mark - 处理订阅数字
- (void)resolveNum {
    //判断下有没有>1000
    NSString *numStr = [NSString stringWithFormat:@"%@万人订阅", _item.sub_number];
    NSInteger num = _item.sub_number.integerValue;
    if (num > 10000) {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.f万人订阅", numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    
    _numView.text = numStr;

}













@end
