//
//  SAAnalytics.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//
#import "SAAnalytics.h"
#import "SAEventInfo.h"
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
    
//    [self performSelectorInBackground:@selector(combinData) withObject:nil];
}

-(void)postDataThread{
    NSData *viewInfoArray = [SAFileManeger readFile:[[SACommon shareInstance] getFilePath ]];  //页面访问信息
//    NSString *eventResponse;
//    NSString *viewResponse;
//    NSString *errorResponse;
    [[SANetWork sharedInstance] doGetWork:@"" params:nil];
    if (viewInfoArray) {
//        [message setObject:@"01" forKey:@"operateType"];
//        eventResponse = [XHPostData postEventInfo:eventArray withPostMessage:message];
    }
    
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
    //修改过
    NSLog(@"%@",dic);
    [[SAAnalytics shareInstance] performSelectorInBackground:@selector(archiveEvent:) withObject:dic];
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
        NSInteger intimer = [[SAAnalytics shareInstance] caculateTimesBetween:date withDate:[NSDate date]];
        stayTimeinteval = [NSString stringWithFormat:@"%ld",(long)intimer];
            
        if (stayTimeinteval) {
            [params setObject:page forKey:@"operateType"];
            [params setObject:stayTimeinteval forKey:@"optParams"];
            [[NSUserDefaults standardUserDefaults] setObject:page forKey:@"fromPage"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FIRST_START"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@startDate",page]];
            [[SAAnalytics shareInstance] performSelectorInBackground:@selector(archiveEvent:) withObject:params];
        }
    }
}


-(void)archiveEvent:(NSDictionary*)postDic{
    @synchronized(self)
    {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FIRST_START"]) {
            SAEventInfo *userViewInfo = [[SAEventInfo alloc]init];
            
            userViewInfo.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
            if (!userViewInfo.userName) {
                userViewInfo.userName = @"";
            }
            if ([postDic objectForKey:@"operateType"]) {
                userViewInfo.operateType = [postDic objectForKey:@"operateType"];
            }
            else userViewInfo.operateType = @"";
                
            if ([postDic objectForKey:@"optParams"]) {
                    userViewInfo.stayTime = [postDic objectForKey:@"optParams"];
                }
            else
                userViewInfo.stayTime = @"";
            if ([postDic objectForKey:@"objId"]) {
                userViewInfo.objId = [postDic objectForKey:@"objId"];
            }
            else
                userViewInfo.objId = @"";
                
            userViewInfo.operateDate = [[SACommon shareInstance] getCurrentDate];
            userViewInfo.productLine = [NSString stringWithFormat:@"%d",(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"productLine"]];
            
            NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
            userViewInfo.appVersion = [NSString stringWithFormat:@"V%@",[dic objectForKey:@"CFBundleVersion"]];
            userViewInfo.deviceModel = [[SACommon shareInstance] deviceString];
            userViewInfo.appChannelId = [SACommon shareInstance].channelId;
            NSData *data = [SAFileManeger readFile:[[SACommon shareInstance] getFilePath ]];
            data = [SAGzipUtility decompressData:data];
                
            NSMutableArray* arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (!arr) {
                arr = [[NSMutableArray alloc] init];
            }
            NSDictionary *viewData = [NSDictionary dictionary];
            viewData = [userViewInfo entityToDictionary:userViewInfo];
            
            [arr addObject:viewData];
            if ([SAFileManeger writeToFile:arr toPath:[[SACommon shareInstance] getFilePath]]) {
                NSLog(@"写入成功");
            }else{
                NSLog(@"写入失败");
            }
        }
    }
}


-(NSInteger)caculateTimesBetween:(NSDate*)date1 withDate:(NSDate*)date2
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *d = [cal components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSInteger sec = [d hour]*3600+[d minute]*60+[d second];
    return sec;
}

@end
