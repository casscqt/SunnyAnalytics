//
//  SAAnalytics.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 发送策略
 */
typedef enum {
    SABATCH = 0,          //Send Data When Start
    SAREALTIME = 1,       //RealTime Send Policy
    SAEVERYDAY = 2,       //EveryDay send Policy
} SAReportPolicy;

@interface Params : NSObject
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) double price;
@end

@interface EventParams : NSObject
@property (copy, nonatomic) NSString *ip;
@property (copy, nonatomic) NSString *source;
@property (copy, nonatomic) NSString *sourceApp;
@property (copy, nonatomic) NSString *deviceId;
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *deviceName;
@property (copy, nonatomic) NSString *netType;
@property (copy, nonatomic) NSString *versionCode;
@property (copy, nonatomic) NSString *sysVersion;
@property (copy, nonatomic) NSString *channel;
@property (strong, nonatomic) Params  *params;
@end

@interface SAAnalytics : NSObject


+(SAAnalytics*)shareInstance;

-(void)postDataThread;


/**
 *  初始化数据统计
 *
 *  @param baseUrl      埋点上传URL
 *  @param reportPolicy 发送策略
 *  @param channelId    渠道ID
 */
+(void)initSAAnalytics:(NSString *)baseUrl  reportPolicy:(SAReportPolicy)reportPolicy channelId:(NSString *) channelId;

/**
 *  按钮事件统计
 *
 *  @param operateType 名称
 *  @param objId       ID
 *  @param optParams   参数
 */
+(void)doEvent:(const NSString*)operateType objectId:(NSString*)objId params:(NSString*)optParams;


/**
 *  实时事件统计
 *
 *  @param operateType 名称
 *  @param objId       ID
 *  @param optParams   参数
 */
+(void)doQuickEvent:(const NSString*)operateType objectId:(NSString*)objId params:(NSString*)optParams;

/**
 *  UIViewController 创建时调用
 *
 *  @param page UIViewController名称
 */
+(void)beginPage:(NSString*)page;

/**
 *  UIViewController 销毁时调用
 *
 *  @param page UIViewController名称
 */
+(void)endPage:(NSString*)page;

@end
