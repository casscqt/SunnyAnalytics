//
//  SAFileManeger.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  gz文件管理
 */
@interface SAFileManeger : NSObject

/**
 *  读取toPath路径下的NSArray类型的内容
 *
 *  @param toPath 读取文件的路径
 *
 *  @return 返回文件data
 */
+ (NSData*)readFile:(NSString *)toPath;

/**
 *  NSArry写到toPath路径下
 *
 *  @param arr    NSArray数据
 *  @param toPath 写入路径
 *
 *  @return return 是否成功
 */
+ (BOOL)writeToFile:(NSArray*)arr toPath:(NSString*)toPath;

/**
 *  删除path内容
 *
 *  @param path 需要删除的文件路径
 *
 *  @return <#return value description#>
 */
+ (BOOL)deleteFile:(NSString*)path;


/**
 *  获取文件创建日期
 *
 *  @param filePath 文件路径
 *
 *  @return 日期String
 */
+(NSDate *)createFileDate:(NSString *)filePath;

@end
