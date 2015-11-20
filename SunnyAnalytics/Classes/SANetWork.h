//
//  SANetWork.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/11/17.
//  Copyright © 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,NetAction) {
    ENUM_BATCH = 1,  //批量请求
    ENUM_SINGLE     //单条数据请求
};

@interface SANetWork : NSObject


+ (SANetWork *)sharedInstance;

/**
 *  发送get网络请求
 *
 *  @param url 服务器地址
 *  @param dic 参数
 *  @param action 请求类型
 */
-(void)doGetWork:(NSMutableDictionary *)dic netType:(NetAction) action;

@end
