//
//  DCacheHelper.h
//  daydays
//
//  Created by jiazhaoyang on 15/8/7.
//  Copyright (c) 2015年 jiazhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCacheHelper : NSObject

/**
 *  统计缓存策略
 */
@property(nonatomic,strong)NSString *sEventStrategy;

/**
 *  策略发送间隔时间
 */
@property(nonatomic,strong)NSString *intervalTime;



- (void)save;

+ (DCacheHelper *)getCacehObj;

@end
