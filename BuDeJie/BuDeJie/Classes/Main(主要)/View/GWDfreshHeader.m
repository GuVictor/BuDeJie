//
//  GWDfreshHeader.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/5/4.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDfreshHeader.h"

@implementation GWDfreshHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //设置状态文字
        self.stateLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        self.stateLabel.font = [UIFont systemFontOfSize:17];
        [self setTitle:@"温馨提示:下拉刷新" forState:MJRefreshStateIdle];
        [self setTitle:@"温馨提示:松开刷新" forState:MJRefreshStatePulling];
        [self setTitle:@"温馨提示:正在刷新" forState:MJRefreshStateRefreshing];
        
        //隐藏时间
        self.lastUpdatedTimeLabel.hidden = YES;
        //自动切换透明度
        self.automaticallyChangeAlpha = YES;
    }
    
    return self;
}
@end
