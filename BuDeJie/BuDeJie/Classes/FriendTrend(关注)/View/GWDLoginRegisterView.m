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

+ (instancetype)GWDLoginView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+ (instancetype)GWDRegisterView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *image = self.loginRegisterButton.currentBackgroundImage;
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
    //让按钮背景图片不要被拉伸
    [_loginRegisterButton setBackgroundImage:image forState:UIControlStateNormal];
}

@end
