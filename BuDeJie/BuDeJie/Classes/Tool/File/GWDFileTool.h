//
//  GWDFile.h
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/17.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWDFileTool : NSObject

/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹路径
 *
 *  @return 返回文件夹尺寸
 */
+ (NSInteger)getFileSize:(NSString *)directoryPath;


/**
 *  删除文件夹所有文件
 *
 *  @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;
@end
