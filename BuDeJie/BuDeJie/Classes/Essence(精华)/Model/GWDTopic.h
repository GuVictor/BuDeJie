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

/** 帖子的类型, 10为图片 29为段子 31为音频 41为视频 */
@property (assign, nonatomic) NSInteger  type;

/** 最热评论 */
@property (strong, nonatomic) NSArray *top_cmt;

/** 宽度(像素) */
@property (assign, nonatomic) NSInteger  width;
/** 高度(像素) */
@property (assign, nonatomic) NSInteger  height;

/** cell中间内容的frame */
@property (assign, nonatomic) CGRect  middleFrame;

/*额外增加属性(并非服务器返回的属性，仅仅是为了提高开发效率)*/
/** 根据当前模型计算出来的cell高度 */
@property (assign, nonatomic) CGFloat  cellHeight;
@end
