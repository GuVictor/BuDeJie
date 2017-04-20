//
//  GWDTabBar.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/12.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDTabBar.h"


@interface GWDTabBar ()

/** 加号按钮 */
@property (weak, nonatomic) UIButton *plusBtn;
/** 上一次点击按钮*/
@property (weak, nonatomic) UIControl *previousClickedTabButton;


@end

@implementation GWDTabBar


#pragma mark - 因为layoutSubviews调用很多次，这里只调用一次所有搞个懒加载
- (UIButton *)plusBtn {
    if (!_plusBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        [btn sizeToFit];
        
        [self addSubview:btn];
        _plusBtn = btn;

    }
    
    return _plusBtn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    NSLog(@"%@", self.subviews);
    /*来源的结果
     "<_UIBarBackground: 0x7f8af3d0bdd0; frame = (0 0; 414 49); userInteractionEnabled = NO; layer = <CALayer: 0x60000022e660>>",
     "<UITabBarButton: 0x7f8af3e15d50; frame = (2 1; 79 48); opaque = NO; layer = <CALayer: 0x60000022fc60>>",
     "<UITabBarButton: 0x7f8af3d05340; frame = (85 1; 79 48); opaque = NO; layer = <CALayer: 0x60000022ff80>>",
     "<UITabBarButton: 0x7f8af3d10af0; frame = (168 1; 78 48); opaque = NO; layer = <CALayer: 0x600000230fc0>>",
     "<UITabBarButton: 0x7f8af3d029a0; frame = (250 1; 79 48); opaque = NO; layer = <CALayer: 0x6080002270e0>>",
     "<UITabBarButton: 0x7f8af3e30160; frame = (333 1; 79 48); opaque = NO; layer = <CALayer: 0x608000227800>>"
     */
    
    //跳转tabBarButton位置
    NSInteger count = self.items.count;
    CGFloat btnW = self.gwd_width / (count + 1); //因为只有四个页面，而下面要显示5个button
    CGFloat btnH = self.gwd_height;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    //私有类：打印出来了有个类，但是敲不出来，说明这个类是系统私有类
    //变量子控件 调整布局
    int i = 0;
    for (UIControl *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
               //设置previousClickTarBarButton默认值为最前面的按钮
            if (i==0 && self.previousClickedTabButton == nil) {//如果重新调用layoutsubView就会改变当前按钮（严谨）
                _previousClickedTabButton = tabBarButton;
            }
            
            if (i == 2) {
                i += 1;
            }
            
            btnX = i * btnW;
            
             i++;
            
            //系统UITabBarButton按钮的frame
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);//错误就在在于放在for外面
            
            //监听按钮测点击
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        
        
       
    }
    
    //发布按钮的位置
    self.plusBtn.center = CGPointMake(self.gwd_width * 0.5, self.gwd_height * 0.5);
    
    
}

#pragma mark - tabbar按钮的点击
- (void)tabBarButtonClick:(UIControl *)tabBarButton {
    
    //发通知
    if (self.previousClickedTabButton == tabBarButton) {
        NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);

        //发出通知,告诉外界tabBarButon被重复点击了
        [[NSNotificationCenter defaultCenter] postNotificationName:GWDTabBarButtonDidRepeatClickNotification object:nil ];
        
    }
    
    self.previousClickedTabButton = tabBarButton;
}

@end
