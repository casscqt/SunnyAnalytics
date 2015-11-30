//
//  SACommon.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/10/29.
//  Copyright © 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NSDictionary *(^PublicParamBlock)();

typedef NS_ENUM(NSInteger,SendPolicy) {
    SEND_START = 1, //启动时发送
    SEND_TIME,       //按间隔发送, value值为时间间隔，秒为单位
    SEND_EXIT,       //退出时发送
};


/**
 *  工具类
 */
@interface SACommon : NSObject{
     NSString *strBaseUrl;
     NSString *strChannelId;
}

/**
 *  上传gz文件地址
 */
@property(nonatomic,strong)NSString *baseUrl;

/**
 *  获取公共请求参数的block，如果你想实现动态更新的公共参数，请使用此属性
 */
@property (nonatomic, copy) PublicParamBlock publickParamBlock;

+(SACommon*)shareInstance;


/**
 *  获取设备名称
 *
 *  @return 设备名称
 */
-(NSString*)deviceString;

/**
 *  获取当前系统时间
 *
 *  @return 系统时间
 */
-(NSString*)getCurrentDate;

/**
 *  获取文件Data
 *
 *  @return 返回data数据
 */
-(NSData *)getFileData;

/**
 *  获取本地缓存文件路径
 *
 *  @return 路径地址
 */
-(NSString *)getFilePath;

/**
 *  计算时间间隔
 *
 *  @param date1 时间1
 *  @param date2 时间2
 *
 *  @return 间隔时间
 */
-(NSInteger)caculateTimesBetween:(NSDate*)date1 withDate:(NSDate*)date2;


/**
 *  获取网络请求默认参数
 *
 *  @return 默认参数
 */
-(NSMutableDictionary *)getDefaultParams;

@end
