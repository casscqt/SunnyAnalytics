//
//  SANetWork.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/11/17.
//  Copyright © 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SANetWork : NSObject



+ (SANetWork *)sharedInstance;

/**
 *  发送get网络请求
 *
 *  @param url 服务器地址
 *  @param dic 参数
 */
-(void)doGetWork:(NSMutableDictionary *)dic;

@end
