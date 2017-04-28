//
//  GWDTopic.h
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/24.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**>>>>>>>>>>>>>>>>>>>>>服务器返回数据类型>>>>>>>>>>>>>>>>>>>>>>>*/

typedef NS_ENUM(NSUInteger, GWDTopicType) {
    /** 全部 */
    GWDTopicTypeAll = 1,
    GWDTopicTypePicture = 10,
    GWDTopicTypeWord = 29,
    GWDTopicTypeVoice = 31,
    GWDTopicTypeVideo = 41
};

@interface GWDTopic : NSObject

/**>>>>>>>>>>>>>>>>>>>>>帖子上面部分>>>>>>>>>>>>>>>>>>>>>>>*/

/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *passtime;

/**>>>>>>>>>>>>>>>>>>>>>帖子底部>>>>>>>>>>>>>>>>>>>>>>>*/


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


/**>>>>>>>>>>>>>>>>>>>>>中间view>>>>>>>>>>>>>>>>>>>>>>>*/
/** 宽度(像素) */
@property (assign, nonatomic) NSInteger  width;
/** 高度(像素) */
@property (assign, nonatomic) NSInteger  height;



@property (nonatomic, strong) NSString *image2;

@property (nonatomic, strong) NSString *image1;

 @property (nonatomic, strong) NSString *image0;

@property (nonatomic, assign) NSInteger videotime;

 @property (nonatomic, assign) NSInteger voicetime;

 @property (nonatomic, assign) NSInteger playcount;

/** cell中间内容的frame */
@property (assign, nonatomic) CGRect  middleFrame;

/*额外增加属性(并非服务器返回的属性，仅仅是为了提高开发效率)*/
/** 根据当前模型计算出来的cell高度 */
@property (assign, nonatomic) CGFloat  cellHeight;

@end


/**>>>>>>>>>>>>>>>>>>>>>服务器返回list中所有属性>>>>>>>>>>>>>>>>>>>>>>>*/

/*
 @property (nonatomic, strong) NSString *create_time;
 
 @property (nonatomic, strong) NSString *image2;
 
 @property (nonatomic, strong) NSString *playcount;
 
 @property (nonatomic, strong) NSString *height;
 
 @property (nonatomic, strong) NSString *id;
 
 @property (nonatomic, strong) NSString *videotime;
 
 @property (nonatomic, strong) NSString *image1;
 
 @property (nonatomic, assign) NSInteger cache_version;
 
 @property (nonatomic, strong) NSString *repost;
 
 @property (nonatomic, strong) NSArray *themes;
 
 @property (nonatomic, strong) NSString *image0;
 
 @property (nonatomic, strong) NSString *text;
 
 @property (nonatomic, strong) NSString *bimageuri;
 
 @property (nonatomic, strong) NSString *videouri;
 
 @property (nonatomic, strong) NSString *hate;
 
 @property (nonatomic, strong) NSString *weixin_url;
 
 @property (nonatomic, strong) NSString *width;
 
 @property (nonatomic, strong) NSString *user_id;
 
 @property (nonatomic, strong) NSString *type;
 
 @property (nonatomic, strong) NSString *voicelength;
 
 @property (nonatomic, strong) NSString *theme_type;
 
 @property (nonatomic, strong) NSString *playfcount;
 
 @property (nonatomic, strong) NSString *tag;
 
 @property (nonatomic, strong) NSString *ding;
 
 @property (nonatomic, strong) NSString *created_at;
 
 @property (nonatomic, strong) NSString *favourite;
 
 @property (nonatomic, strong) NSString *passtime;
 
 @property (nonatomic, strong) NSString *theme_id;
 
 @property (nonatomic, strong) NSString *name;
 
 @property (nonatomic, strong) NSString *bookmark;
 
 @property (nonatomic, strong) NSString *theme_name;
 
 @property (nonatomic, strong) NSString *original_pid;
 
 @property (nonatomic, strong) NSString *love;
 
 @property (nonatomic, strong) NSString *cai;
 
 @property (nonatomic, strong) NSString *status;
 
 @property (nonatomic, strong) NSString *voiceuri;
 
 @property (nonatomic, assign) NSInteger t;
 
 @property (nonatomic, strong) NSString *screen_name;
 
 @property (nonatomic, strong) NSString *voicetime;
 
 @property (nonatomic, strong) NSString *is_gif;
 
 @property (nonatomic, strong) NSString *comment;
 
 @property (nonatomic, strong) NSArray *top_cmt;
 
 @property (nonatomic, strong) NSString *profile_image;
 */
