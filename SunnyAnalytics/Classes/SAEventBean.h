//
//  SAEventBean.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/11/19.
//  Copyright © 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAEventBean : NSObject

/**
 * 事件名称-必填
 */
@property(nonatomic,copy)NSString *uniqueCode;

/**
 *  来源(10 web  20 android  30 IOS)-必填
 */
@property(nonatomic,copy)NSString *source;

/**
 *  0 网络教辅 1 天天象上 2 智能教辅 3 名师辅导 4 名校好卷 5 错题笔记 6 天天扫题-必填
 */
@property(nonatomic,copy)NSString *sourceApp;

/**
 *  设备唯一id-必填
 */
@property(nonatomic,copy)NSString *deviceId;
/**
 *  设备名称-必填
 */
@property(nonatomic,copy)NSString *deviceName;
/**
 *  产品版本号-必填
 */
@property(nonatomic,copy)NSString *versionCode;
/**
 *  系统版本号-必填
 */
@property(nonatomic,copy)NSString *sysVersion;

/**
 *  渠道-必填
 */
@property(nonatomic,copy)NSString *channel;

/**
 *  网络类型(2G=1；3G=2；4G=3；wifi=4;其他=5)-必填
 */
@property(nonatomic,copy)NSString *netType;

/**
 *  数据产生的真实时间-必填
 */
@property(nonatomic,copy)NSString *realTime;

/**
 *  ip地址
 */
@property(nonatomic,copy)NSString *ip;

/**
 *  城市名
 */
@property(nonatomic,copy)NSString *city;
/**
 *  省份名
 */
@property(nonatomic,copy)NSString *province;
/**
 *  国家
 */
@property(nonatomic,copy)NSString *country;

/**
 *  订阅名师	{"userId":""," orderId ":""}	用户id，订单id
 购买视频	{"userId":""," orderId ":""}	用户id，订单id
 用户付费	{"userId":""," orderId ":""}	用户id，订单id
 启动应用	{"userId":"","comeData":""，"leaveData":""}	用户id(用户登录后传值)，进入和离开页面的数据点
 */
@property(nonatomic,copy)NSString *content;


//=======以下服务器暂未使用=========
/**
 *  UIViewController停留的时间
 */
@property(nonatomic,copy)NSString *stayTime;

/**
 *  ID
 */
@property(nonatomic,copy)NSString *objId;



-(NSMutableDictionary*)entityToDictionary:(id)obj;

@end
