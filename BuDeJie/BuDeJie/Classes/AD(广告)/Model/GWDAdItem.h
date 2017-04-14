//
//  GWDAdItem.h
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/14.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWDAdItem : NSObject
/** 广告地址 */
@property (nonatomic, strong) NSString *w_picurl;
/** 点击广告跳转的界面 */
@property (nonatomic, strong) NSString *ori_curl;

@property (nonatomic, assign) CGFloat w;

@property (nonatomic, assign) CGFloat h;
@end
