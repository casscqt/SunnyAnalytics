//
//  SAFileManeger.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import "SAFileManeger.h"
#import "SAGzipUtility.h"
@implementation SAFileManeger

+ (NSData*)readFile:(NSString *)toPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取真机下的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];  // Documents
    //  stringByExpandingTildeInPath 将路径中的代字符扩展成用户主目录（~）或指定用户主目录（~user）
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:toPath];
    if ([fileManager fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        return data;
    }
    return nil;
}

+ (BOOL)writeToFile:(NSArray*)arr toPath:(NSString*)toPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:toPath];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    data = [SAGzipUtility compressData:data];
    return [data writeToFile:path atomically:NO];
}

+ (BOOL)deleteFile:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    // 找到path所在的路径
    NSString *topath = [documentsDirectory stringByAppendingPathComponent:path];
    NSData *data = [[NSData alloc] init];
    // 把空的数组写到path所在的位置，即删除了原来的path内容
    [data writeToFile:topath atomically:NO];
    return YES;
}
@end
