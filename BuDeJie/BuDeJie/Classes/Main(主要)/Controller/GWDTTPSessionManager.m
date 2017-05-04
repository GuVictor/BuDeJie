//
//  GWDTTPSessionManager.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/5/4.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDTTPSessionManager.h"

@implementation GWDTTPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        //设备类型，是iPhone还是iPad，tv
        [self.requestSerializer setValue:[UIDevice currentDevice].model forHTTPHeaderField:@"Phone"];
        //系统版本
        [self.requestSerializer setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"OS"];
    }
    
    return self;
}
@end
