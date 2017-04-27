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

@end

@implementation GWDTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *image = [UIImage imageNamed:@"mainCellBackground"];
    UIImage *stretchImage = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    self.backgroundView = [[UIImageView alloc] initWithImage:stretchImage];
}

#pragma mark - 设置数据
- (void)setTopic:(GWDTopic *)topic {
    _topic = topic;
    
    //顶部控件的数据
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[[UIImage imageNamed:@"defaultUserIcon"] gwd_circleImage] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //图片下载失败直接返回，安装它的默认做法
        if (!image) return ;
        
        self.profileImageView.image = [image gwd_circleImage];
    }];
    
    self.nameLabel.text = topic.name;
    self.passtimeLabel.text = topic.passtime;
    self.text_label.text = topic.text;
    
    //设置按钮的文字
    [self setupButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:topic.comment placeholder:@"评论"];
    
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
