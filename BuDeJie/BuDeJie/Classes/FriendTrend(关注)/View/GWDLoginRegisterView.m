//
//  GWDLoginRegisterView.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/15.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDLoginRegisterView.h"

@interface GWDLoginRegisterView ()
@property (weak, nonatomic) IBOutlet UIButton *loginRegisterButton;

@end

@implementation GWDLoginRegisterView

#pragma mark - 加载登录界面
+ (instancetype)GWDLoginView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

#pragma mark - 加载注册界面
+ (instancetype)GWDRegisterView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

#pragma mark - 重xib加载必调用的，处理xib里控件的一些东西
- (void)awakeFromNib {
    [super awakeFromNib];
    //因为从xib加载所有，图片会拉伸，所有从新设置设置没有拉伸的图片
    UIImage *image = self.loginRegisterButton.currentBackgroundImage;
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
    //让按钮背景图片不要被拉伸
    [_loginRegisterButton setBackgroundImage:image forState:UIControlStateNormal];
}

@end
