//
//  SAAnalytics.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//
#import "SAAnalytics.h"
#import "SAEventBean.h"
#import "SAFileManeger.h"
#import "SAGzipUtility.h"
#import "SANetWork.h"
#import "SACommon.h"

@implementation SAAnalytics

+(SAAnalytics*)shareInstance
{
    static SAAnalytics *instance = nil;
    if (instance == nil) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}

+(void)initSAAnalytics:(NSString *)baseUrl  reportPolicy:(SAReportPolicy)reportPolicy channelId:(NSString *)channelId{
    
    [[SACommon shareInstance] setBaseUrl:baseUrl];
    [[SACommon shareInstance] setChannelId:channelId];
    [[SAAnalytics shareInstance] initWithReportPolicy:reportPolicy];
}

-(void)initWithReportPolicy:(SAReportPolicy)postPolicy{
    
    switch (postPolicy) {
        case SABATCH:
            
            break;
            
        case SAREALTIME:
            
            break;
            
        case SAEVERYDAY:{
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSString *firstDate = [[SACommon  shareInstance ]getCurrentDate];
                
                [[NSUserDefaults standardUserDefaults] setObject:firstDate forKey:@"firstDate"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            [self postDataThread];
        }
            break;
            
        default:
            break;
    }
}

-(void)postDataThread{
//    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:arActions options:NSJSONReadingAllowFragments error:nil];
    NSData *dataArray = [SAFileManeger readFile:[[SACommon shareInstance] getFilePath ]];
    NSArray *arActions = [NSKeyedUnarchiver unarchiveObjectWithData:dataArray];
    NSString *strActions = [arActions componentsJoinedByString:@" "];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    [dicParams setObject:strActions forKey:@"jsonParams"];
    [[SANetWork sharedInstance] doGetWork:dicParams];
    
}

+(void)doEvent:(NSString*)operateType objectId:(NSString*)objId params:(NSString*)optParams
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (operateType) {
        [dic setObject:operateType forKey:@"operateType"];
    }
    if (objId) {
        [dic setObject:objId forKey:@"objId"];
    }
    if (optParams) {
        [dic setObject:optParams forKey:@"optParams"];
    }
    [dic setObject:[NSDate date] forKey:@"startDate"];
    NSLog(@"%@",dic);
    [[SAAnalytics shareInstance] performSelectorInBackground:@selector(archiveFileEvent:) withObject:dic];
}

+(void)doQuickEvent:(NSString*)operateType objectId:(NSString*)objId params:(NSString*)optParams{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (operateType) {
        [dic setObject:operateType forKey:@"operateType"];
    }
    if (objId) {
        [dic setObject:objId forKey:@"objId"];
    }
    if (optParams) {
        [dic setObject:optParams forKey:@"optParams"];
    }
    [dic setObject:[NSDate date] forKey:@"startDate"];
    NSLog(@"%@",dic);
    [[SAAnalytics shareInstance] performSelectorInBackground:@selector(archiveQuickEvent:) withObject:dic];
}


+(void)beginPage:(NSString*)page
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"startFailed"])
    {
//        [[NSUserDefaults standardUserDefaults] setObject:page forKey:@"page"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[NSString stringWithFormat:@"%@startDate",page]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }

}
+(void)endPage:(NSString*)page{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"startFailed"]){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *stayTimeinteval;
        NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@startDate",page]];
        NSInteger intimer = [[SACommon shareInstance] caculateTimesBetween:date withDate:[NSDate date]];
        stayTimeinteval = [NSString stringWithFormat:@"%ld",(long)intimer];
            
        if (stayTimeinteval) {
            [params setObject:page forKey:@"operateType"];
            [params setObject:stayTimeinteval forKey:@"optParams"];
            [[NSUserDefaults standardUserDefaults] setObject:page forKey:@"fromPage"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FIRST_START"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@startDate",page]];
            [[SAAnalytics shareInstance] performSelectorInBackground:@selector(archiveFileEvent:) withObject:params];
        }
    }
}

-(NSMutableDictionary *)bindEventData:(NSDictionary *)postDic{
    SAEventBean *eventBean = [[SAEventBean alloc]init];
    
    if ([postDic objectForKey:@"operateType"]) {
        eventBean.uniqueCode = [postDic objectForKey:@"operateType"];
    }else{
        eventBean.uniqueCode = @"";
    }
    eventBean.source = @"30";
    eventBean.sourceApp = @"1";
    eventBean.deviceId = @"123456";
    eventBean.deviceName = @"ios_sim";
    eventBean.netType = @"4";
    eventBean.realTime = [[SACommon shareInstance] getCurrentDate];
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    eventBean.versionCode = [NSString stringWithFormat:@"V%@",[dic objectForKey:@"CFBundleShortVersionString"]];
    eventBean.sysVersion = [[SACommon shareInstance] deviceString];
    eventBean.channel = [SACommon shareInstance].channelId;
    
    
    if ([postDic objectForKey:@"optParams"]) {
        eventBean.stayTime = [postDic objectForKey:@"optParams"];
    }else{
        eventBean.stayTime = @"";
    }
    if ([postDic objectForKey:@"objId"]) {
        eventBean.objId = [postDic objectForKey:@"objId"];
    }else{
        eventBean.objId = @"";
    }
    
    NSMutableDictionary *viewData = [NSMutableDictionary dictionary];
    viewData = [eventBean entityToDictionary:eventBean];
    return viewData;
}

/**
 *  写入文件操作
 *
 *  @param postDic 数据集
 */
-(void)archiveFileEvent:(NSDictionary*)postDic{
    @synchronized(self)
    {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FIRST_START"]) {
                
                NSData *data = [SAFileManeger readFile:[[SACommon shareInstance] getFilePath ]];
                //                data = [SAGzipUtility decompressData:data];
                NSMutableArray* arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if (!arr) {
                    arr = [[NSMutableArray alloc] init];
                }
                [arr addObject:[self bindEventData:postDic]];
                
                if ([SAFileManeger writeToFile:arr toPath:[[SACommon shareInstance] getFilePath]]) {
                    NSLog(@"写入成功");
                }else{
                    NSLog(@"写入失败");
                }
        }
    }
}

/**
 *  实时事件发送
 *
 *  @param postDic 数据集
 */
-(void)archiveQuickEvent:(NSDictionary*)postDic{
    @synchronized(self)
    {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FIRST_START"]) {
            [[SANetWork sharedInstance] doGetWork:[self bindEventData:postDic]];
        }
    }
}


@end
