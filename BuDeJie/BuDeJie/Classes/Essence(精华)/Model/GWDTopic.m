//
//  GWDTopic.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/24.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDTopic.h"

@implementation GWDTopic

- (CGFloat)cellHeight {
    //如果已经计算过,就直接返回
    if (_cellHeight) return _cellHeight;
    
    //文字的Y值
    _cellHeight += 55;
    
    //文字的高度
    CGSize textMaxSize = CGSizeMake(GWDScreenW - 2 * GWDMarin, MAXFLOAT);
    
    _cellHeight += [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + GWDMarin;
    
    //工具条
    _cellHeight += 35 + GWDMarin;
    
    //最热评论
    if (self.top_cmt.count) {//有最热评论
        //标题
        _cellHeight += 21;
        
        //内容
        NSDictionary *cmt = self.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        
        NSString *username= cmt[@"user"][@"username"];
        NSString *cmtText = [NSString stringWithFormat:@"%@ : %@", username, content];
        
        _cellHeight += [cmtText boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height + GWDMarin;
    }
    
    return _cellHeight;
}
@end
