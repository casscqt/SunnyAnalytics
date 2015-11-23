//
//  DCacheHelper.m
//  daydays
//
//  Created by jiazhaoyang on 15/8/7.
//  Copyright (c) 2015年 jiazhaoyang. All rights reserved.
//

#import "DCacheHelper.h"

#define CACHE_OBJECT @"cacheObject"
#define CACHE_Strategy @"sEventStrategy"
#define CACHE_intervalTime @"intervalTime"

@implementation DCacheHelper


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.sEventStrategy forKey:CACHE_Strategy];
    [encoder encodeObject:self.intervalTime forKey:CACHE_intervalTime];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        _sEventStrategy = [decoder decodeObjectForKey:CACHE_Strategy];
        _intervalTime = [decoder decodeObjectForKey:CACHE_intervalTime];
    }
    return self;
}

- (void)save
{
    dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:self];
      [[NSUserDefaults standardUserDefaults] setObject:encodeData forKey:CACHE_OBJECT];
      [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

+ (DCacheHelper *)getCacehObj
{
    static DCacheHelper *_singleton;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
      NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
      NSData *data = [userDefault objectForKey:CACHE_OBJECT];
      if (!data) {
          _singleton = [[DCacheHelper alloc] init];
      }
      else {
          _singleton = [NSKeyedUnarchiver unarchiveObjectWithData:data];
          if (!_singleton) {
              _singleton = [[DCacheHelper alloc] init];
          }
      }
    });

    return _singleton;
}

@end
