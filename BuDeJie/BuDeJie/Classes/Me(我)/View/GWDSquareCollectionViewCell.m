//
//  GWDSquareCollectionViewCell.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/16.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDSquareCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "GWDSquareItem.h"
@interface GWDSquareCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *textL;

@end

@implementation GWDSquareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(GWDSquareItem *)item {
    _item = item;
    
    [self.imageV sd_setImageWithURL:[NSURL  URLWithString:item.icon]];
    self.textL.text = item.name;
}

@end
