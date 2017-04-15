//
//  GWDFastButton.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/15.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDFastButton.h"

@implementation GWDFastButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    //设置图片位置
    self.imageView.gwd_x = 0;
    self.imageView.gwd_centerX = self.gwd_width * 0.5;
    //设置标题位置
    self.titleLabel.gwd_y = self.gwd_height - self.titleLabel.gwd_height;
    
    //计算文字宽度，设置label的宽度, 会改center的x
    [self.titleLabel sizeToFit];
    
    self.titleLabel.gwd_centerX = self.gwd_width * 0.5;
}
@end
