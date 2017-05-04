//
//  GWDDIYHeader.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/5/4.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDDIYHeader.h"

@interface GWDDIYHeader ()
/** 开关 */
@property (weak, nonatomic) UISwitch *sw;
/** logo */
@property (weak, nonatomic) UIImageView *logo;

@end

@implementation GWDDIYHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UISwitch *sw = [[UISwitch alloc] init];
        [self addSubview:sw];
        self.sw = sw;
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
        [self addSubview:logo];
        self.logo = logo;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.logo.gwd_centerX = self.gwd_width * 0.5;
    self.logo.gwd_y = - self.logo.gwd_height - 19;
    
    self.sw.gwd_centerX = self.gwd_width * 0.5;
    self.sw.gwd_centerY = self.gwd_height * 0.5;
    
 
    NSLog(@"%@", NSStringFromCGRect(self.frame));
    NSLog(@"%@", NSStringFromCGRect(self.logo.frame));
    /*2017-05-05 00:08:31.681 BuDeJie[5955:371424] {{0, -54}, {375, 54}}
     2017-05-05 00:08:31.681 BuDeJie[5955:371424] {{134, -38}, {107, 19}}*/

}

#pragma mark - 重写header内部的方法
- (void)setState:(MJRefreshState)state {
    [super setState:state];
    
    if (state == MJRefreshStateIdle) {
        [self.sw setOn:NO animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.sw.transform = CGAffineTransformIdentity;
        }];
    } else if (state == MJRefreshStatePulling) { //松开立即属性
        [self.sw setOn:YES animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.sw.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        [self.sw setOn:YES animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.sw.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
}



@end
