//
//  GWDSubTagTableViewCell.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/14.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDSubTagTableViewCell.h"
#import "GWDSubTagItem.h"
#import <UIImageView+WebCache.h>
@interface GWDSubTagTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *numView;

@end
@implementation GWDSubTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(GWDSubTagItem *)item {
    _item = item;
    
    _nameView.text = item.theme_name;
    _numView.text = item.sub_number;
    
    [_iconImageV sd_setImageWithURL:[NSURL URLWithString:item.image_list]];
}
@end
