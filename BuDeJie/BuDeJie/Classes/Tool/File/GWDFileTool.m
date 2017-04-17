//
//  GWDFile.m
//  BuDeJie
//
//  Created by 古伟东 on 2017/4/17.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "GWDFileTool.h"

@implementation GWDFileTool

#pragma mark - 给一个路径，帮您删除该路径下所有的文件，不包括文件夹？
+ (void)removeDirectoryPath:(NSString *)directoryPath {
    //获得文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    //判断路径是否是存在，还是文件夹，如果不存在或不是文件夹抛出异常
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
#warning 路径不存在或不是文件夹
    if (!isExist || !isDirectory) {
        //抛出异常
        
        //name:异常名称
        //reason:报错原因
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"笨蛋 需要传入的是文件夹路径,并且路径要存在, 不要瞎几把传其他字符串" userInfo:nil];
        [excp raise];
    }
    
    //获取cache文件夹下所有文件和文件夹, 不包括文件夹下的子路径
    NSArray *subPahts = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
//    NSLog(@"%@   %d", subPahts, __LINE__);
    
    
    //拼接路径
    for (NSString *subPath in subPahts) {
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        //删除路径
        [mgr removeItemAtPath:filePath error:nil];
    }
    
}

#pragma mark - 自己去计算SDwebImage做的缓存

+ (void)getFileSize:(NSString *)directoryPath completion: (void(^)(NSInteger)) completion{
    //获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];

    //判断路径是否是存在，还是文件夹，如果不存在或不是文件夹抛出异常
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
#warning 路径不存在或不是文件夹
    if (!isExist || !isDirectory) {
        //抛出异常
        
        //name:异常名称
        //reason:报错原因
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"笨蛋 需要传入的是文件夹路径,并且路径要存在, 不要瞎几把传其他字符串" userInfo:nil];
        [excp raise];
    }
    
    //获取文件夹下所有的子路径,包含子路径的子路径
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
//        NSLog(@"%@, %d", subPaths, __LINE__);
        
        NSInteger totalSize = 0;

        
        for (NSString *subPath in subPaths) {
            //获取文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            //判断是否是隐藏文件
            if ([filePath containsString:@".DS"]) {
                continue;
            }
            
            //判断是否是文件夹
            BOOL isDirectory;
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            
            //判断文件是否存在，并且判断是否是文件夹
            if (!isExist || isDirectory) {
                continue;//如果判断文件路径不存在，或者他是文件夹，进入次循环，本次不计算
            }
            
            //获取文件属性
            NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
            
            
            //获取文件尺寸
            NSInteger fileSize = [attr fileSize];
            
            totalSize += fileSize;
        }
        
        //计算完成回调
        //注意会主线程回调必须在子线程才能回去，不要写到外面去了
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                NSLog(@"%@, line = %d", [NSThread currentThread], __LINE__);
                completion(totalSize);
                NSLog(@"%ld, %d", totalSize, __LINE__);
            }
        });
        

    });
    
   
    
}










@end
