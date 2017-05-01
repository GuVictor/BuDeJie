//
//  GWDTopicCell.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/26.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDTopicCell.h"
#import "GWDTopic.h"
#import <UIImageView+WebCache.h>
#import "GWDTopicVideoView.h"
#import "GWDVoiceView.h"
#import "GWDPictureView.h"

@interface GWDTopicCell ()

/*
 插件的安装路径
 1.旧版本路径：/Users/用户名/Library/Application Support/Developer/Shared/Xcode/Plug-ins
 2.新版本路径：/Users/用户名/Library/Developer/Xcode/Plug-ins
 */

//控件命名 -> 功能 + 控件类型
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;

//中间控件（声音， 视频， 图片）
/** 图片控件 */
@property (weak, nonatomic) GWDPictureView *pictureView;
/** 视频控件 */
@property (weak, nonatomic) GWDTopicVideoView *videoView;
/** 声音控件 */
@property (weak, nonatomic) GWDVoiceView *voiceView;



@end

@implementation GWDTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *image = [UIImage imageNamed:@"mainCellBackground"];
    UIImage *stretchImage = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    self.backgroundView = [[UIImageView alloc] initWithImage:stretchImage];
}

#pragma mark - 懒加载
- (GWDPictureView *)pictureView {
    if (!_pictureView) {
        GWDPictureView *pictureView = [GWDPictureView gwd_viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    
    return _pictureView;
}

- (GWDTopicVideoView *)videoView {
    if (!_videoView) {
        _videoView = [GWDTopicVideoView gwd_viewFromXib];
        [self.contentView addSubview:_videoView];
    }
    
    return _videoView;
}

- (GWDVoiceView *)voiceView {
    if (!_voiceView) {
        GWDVoiceView *voiceView = [GWDVoiceView gwd_viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    
    return _voiceView;
}

#pragma mark - 设置数据
- (void)setTopic:(GWDTopic *)topic {
    _topic = topic;
    
    //顶部控件的数据
    [self.profileImageView gwd_setHeader:topic.profile_image];
//    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[[UIImage imageNamed:@"defaultUserIcon"] gwd_circleImage] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        //图片下载失败直接返回，安装它的默认做法
//        if (!image) return ;
//        
//        self.profileImageView.image = [image gwd_circleImage];
//    }];
    
    self.nameLabel.text = topic.name;
    self.passtimeLabel.text = topic.passtime;
    self.text_label.text = topic.text;
    
    //设置按钮的文字
    [self setupButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:topic.comment placeholder:@"评论"];
    
    //最热评论
    if (self.topic.top_cmt.count) {
        self.topCmtView.hidden = NO;
        
        NSDictionary *cmt = topic.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) {//语音评论
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
    }else {
        self.topCmtView.hidden = YES;
    }
    
    //中间的内容
    if (topic.type == GWDTopicTypePicture) {
        //图片
        self.pictureView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        
    } else if (topic.type == GWDTopicTypeVoice){
        //声音
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.videoView.hidden = YES;
#warning  模型传递
        _voiceView.topic = _topic;
        
    } else if (topic.type == GWDTopicTypeVideo) {
        //视频
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
    } else {
        //段子
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
}

#pragma mark - 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (self.topic.type) {
        case GWDTopicTypePicture:
            self.pictureView.frame = self.topic.middleFrame;
            break;
        case GWDTopicTypeVoice:
            self.voiceView.frame = self.topic.middleFrame;
            break;
        case GWDTopicTypeVideo:
            self.videoView.frame = self.topic.middleFrame;
            break;
            
        default:
            break;
    }
}


/**
 设置按钮文字

 @param button <#button description#>
 @param number 按钮的数字
 @param placeholder 数字为0时显示的文字
 */
- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder {
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame {
//    frame.origin.x += GWDMarin; 中间显示
//    frame.size.height -= 2 * GWDMarin;
    
    frame.size.height -= GWDMarin;
    
    [super setFrame:frame];
}



@end
