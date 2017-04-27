//
//  GWDTopic.h
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/24.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GWDTopicType) {
    /** 全部 */
    GWDTopicTypeAll = 1,
    GWDTopicTypePicture = 10,
    GWDTopicTypeWord = 29,
    GWDTopicTypeVoice = 31,
    GWDTopicTypeVideo = 41
};

@interface GWDTopic : NSObject
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *passtime;

/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
@end
