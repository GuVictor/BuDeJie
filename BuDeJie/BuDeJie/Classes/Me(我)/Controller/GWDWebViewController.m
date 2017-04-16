//
//  GWDWebViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/16.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDWebViewController.h"
#import <WebKit/WebKit.h>

@interface GWDWebViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goforwardBtn;

@property (weak, nonatomic) IBOutlet WKWebView *webView;


@end

@implementation GWDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加webView
    WKWebView *webView = [[WKWebView alloc] init];
    
    [self.contentView addSubview:webView];
    _webView = webView;
    
    //展示网页
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [webView loadRequest:request];
    
    // KVO监听属性改变
    /*
     Observer:观察者
     KeyPath:观察webView哪个属性
     options:NSKeyValueObservingOptionNew:观察新值改变
     
     KVO注意点.一定要记得移除
     */
    
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];

    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.webView.frame = self.contentView.frame;
}

#pragma mark - 控制器销毁时，移除监听器
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
     [self.webView removeObserver:self forKeyPath:@"canGoForward"];
     [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - 监听器回应方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    self.goBackBtn.enabled = self.webView.canGoBack;
    self.goforwardBtn.enabled = self.webView.canGoForward;
    self.title = self.webView.title;
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden = self.webView.estimatedProgress >= 1;
}

#pragma mark - 刷新
- (IBAction)ClickRefresh:(UIBarButtonItem *)sender {
    [self.webView reload];
}
#pragma mark - 后退
- (IBAction)ClickGoBack:(id)sender {
    [self.webView goBack];
}
#pragma mark - 前进
- (IBAction)ClickGoForward:(id)sender {
    [self.webView goForward];
}
@end
