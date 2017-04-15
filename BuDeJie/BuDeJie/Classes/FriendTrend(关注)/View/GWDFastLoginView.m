//
//  GWDFastLoginView.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/15.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDFastLoginView.h"

@implementation GWDFastLoginView

+ (instancetype)fastLoginView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
@end
