//
//  GWDLoginRegisterViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/15.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDLoginRegisterViewController.h"
#import "GWDLoginRegisterView.h"
#import "GWDFastLoginView.h"
@interface GWDLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *MiddleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadCons;
@property (weak, nonatomic) IBOutlet UIView *BottonView;

@end

@implementation GWDLoginRegisterViewController
#pragma mark - View声明周期

//1.划分结构(顶部 中间 底部) /2.一个结构一个
//3.越复杂的界面 越要分装(复用)
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
        屏幕适配
     1.一个view从xib加载，一定要重新设置一下frame
     2. 在viewDidLoad设置控件frame好不好,开发中一般在viewDidLayoutSubvies布局子控件
     */
    
   
    //创建登录View
    GWDLoginRegisterView *loginView = [GWDLoginRegisterView GWDLoginView];
    [self.MiddleView addSubview:loginView];

    //创建注册界面
    GWDLoginRegisterView *logingView = [GWDLoginRegisterView GWDRegisterView];
    [self.MiddleView addSubview:logingView];
    
    //添加快速登录view
    GWDFastLoginView *fastLoginView = [GWDFastLoginView fastLoginView];
    [self.BottonView addSubview:fastLoginView];
    
}

#pragma mark - 点击关闭按钮
- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击注册按钮
- (IBAction)clickRegister:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    //平移中间View
    _leadCons.constant = _leadCons.constant == 0 ? -self.MiddleView.gwd_width * 0.5 : 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - viewDidLayoutSubviews:才会根据布局调整控件的尺寸
- (void)viewDidLayoutSubviews {
    //一定要调用super
    [super viewDidLayoutSubviews];
    
    GWDLoginRegisterView *loginView = self.MiddleView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.MiddleView.gwd_width * 0.5, self.MiddleView.gwd_height );
    
    GWDLoginRegisterView *registerView = self.MiddleView.subviews[1];
    registerView.frame = CGRectMake(self.MiddleView.gwd_width * 0.5, 0, self.MiddleView.gwd_width * 0.5, self.MiddleView.gwd_height);
    
    GWDFastLoginView *fastLoginView = self.BottonView.subviews.firstObject;
    fastLoginView.frame = self.BottonView.bounds;
    
}

#pragma mark - 点击结束编辑
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.MiddleView endEditing:YES];
}


@end
