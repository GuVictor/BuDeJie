//
//  NSString+SizeStr.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/5/5.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "NSString+SizeStr.h"

@implementation NSString (SizeStr)

#pragma mark - 获取百思缓存尺寸字符串,计算MB,KB,B
+ (NSString *)sizeStr:(NSInteger)totalSize {
    
    NSString *sizeStr = @"清除缓存";
    
    
    if (totalSize > 1000 * 1000) {
        //MB
        
        CGFloat sizeF = totalSize / 1000.0 /1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fMB)", sizeStr, sizeF];
    }else if (totalSize > 1000) {
        //KB
        CGFloat sizeF = totalSize / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fKB)", sizeStr, sizeF];
        
    }else if (totalSize > 0) {
        sizeStr = [NSString stringWithFormat:@"%@(%ldB)", sizeStr, totalSize];
    }
    
    return sizeStr;
    
}

@end
