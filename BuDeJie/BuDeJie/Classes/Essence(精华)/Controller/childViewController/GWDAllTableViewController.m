//
//  GWDAllTableViewController.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/18.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDAllTableViewController.h"
#import <AFNetworking.h>
#import "GWDTopic.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "GWDTopicCell.h"
#import "NSDictionary+Property.h"
@interface GWDAllTableViewController ()

@end

@implementation GWDAllTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}


- (GWDTopicType)type {
    return GWDTopicTypeAll;
}


@end
