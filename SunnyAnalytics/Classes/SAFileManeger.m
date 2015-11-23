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
    if ([fileManager fileExistsAtPath:toPath]) {
        NSData *data = [NSData dataWithContentsOfFile:toPath];
        return data;
    }
    return nil;
}

+(NSDate *)createFileDate:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
        if (fileAttributes != nil) {
//            NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
//            NSString *fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName];
//            NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
            NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
            return fileCreateDate;
        }
    }
    return nil;
}

+ (BOOL)writeToFile:(NSArray*)arr toPath:(NSString*)toPath
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
//    data = [SAGzipUtility compressData:data];
    return [data writeToFile:toPath atomically:NO];
}

+ (BOOL)deleteFile:(NSString*)path
{
    NSData *data = [[NSData alloc] init];
    // 把空的数组写到path所在的位置，即删除了原来的path内容
    [data writeToFile:path atomically:NO];
    return YES;
}
@end
