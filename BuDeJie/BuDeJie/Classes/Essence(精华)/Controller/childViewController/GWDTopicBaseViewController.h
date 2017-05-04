//
//  GWDTopicBaseViewController.h
//  BuDeJie
//
//  Created by 古伟东 on 2017/5/4.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWDTopic.h"
@interface GWDTopicBaseViewController : UITableViewController
//其实没有必要生成set方法的属性
/** 帖子的类型 */
//@property (nonatomic, assign, readonly) XMGTopicType type;

- (GWDTopicType)type;

@end
