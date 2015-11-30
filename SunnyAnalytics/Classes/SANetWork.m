//
//  SANetWork.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/11/17.
//  Copyright © 2015年 gitpark. All rights reserved.
//

#import "SANetWork.h"
#import "SAFileManeger.h"
#import "AFNetworking.h"
#import "SACommon.h"
#import "DCacheHelper.h"

#define SERVER_OUT_INTERVAL 10   //网络超时时间

@implementation SANetWork

+ (SANetWork *)sharedInstance{
    static SANetWork *netWork = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        netWork = [[self alloc] init];
    });
    return netWork;
}

-(void)getStrategy:(void(^)(void))successBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:SERVER_OUT_INTERVAL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"text/javascript",@"application/json",@"text/html",@"text/plain", nil] ;
    
    [manager GET:[[SACommon shareInstance].baseUrl stringByAppendingString:@"getStrategy.do"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        //type=1,按启动时发送，type=2,按间隔发送, value值为时间间隔，秒为单位，type=3,退出时发送
        NSString *strType =  [responseObject objectForKey:@"type"];
        [DCacheHelper getCacehObj].sEventStrategy = strType;
        if ([strType isEqualToString:@(SEND_TIME)]) {
            [DCacheHelper getCacehObj].intervalTime =  [responseObject objectForKey:@"interval"];
        }
        [[DCacheHelper getCacehObj] save];
        if (successBlock) {
            successBlock();
        }
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error){

    }];
    
}

-(void)doAnalyticsWork:(NSMutableDictionary *)dic netType:(NetAction) action{
    NSString *serverUrl;
    if (action == ENUM_BATCH) {
        serverUrl = [[SACommon shareInstance].baseUrl stringByAppendingString:@"collectBatch.do"];
    }else{
        serverUrl = [[SACommon shareInstance].baseUrl stringByAppendingString:@"collect.do"];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:SERVER_OUT_INTERVAL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"text/javascript",@"application/json",@"text/html",@"text/plain", nil] ;
    
    if (action == ENUM_BATCH) {
        [manager POST:serverUrl parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SAFileManeger deleteFile:[[SACommon shareInstance] getFilePath]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SAFileManeger deleteFile:[[SACommon shareInstance] getFilePath]];
        }];
    }else{
        [dic addEntriesFromDictionary:[[SACommon shareInstance] getDefaultParams]];
        [manager GET:serverUrl parameters:dic success:^(NSURLSessionDataTask *task, id responseObject){
            
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            
        }];
    }
}


///**
// *  上传文件接口，暂时未启用
// */
//-(void)uploadData
//{
//    //    NSString *fileName = @"hmt";
//    //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    //    [dic setObject:@"operate" forKey:@"operateType"];
//    //    NSArray *arr = @[dic];
//    //    [SAFileManeger writeToFile:arr toPath:VIEWINFO_PATH];
//    
//    //  确定需要上传的文件(假设选择本地的文件)
//    NSURL*theurl=[NSURL fileURLWithPath:[[SACommon shareInstance] getFilePath] ];
//    NSData *data = [NSData dataWithContentsOfURL:theurl];
//    NSURL *url = [NSURL URLWithString:[SACommon shareInstance].baseUrl];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setTimeoutInterval:5.0];
//    [request setHTTPMethod:@"POST"];
//    
//    //    [request setHTTPBody:[data base64EncodedDataWithOptions:NSUTF8StringEncoding]];
//    //    [request setValue:@"" forKey:@"Content-Type"];
//    //    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//    
//    
//    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    NSMutableData *body = [NSMutableData data];
//    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
//    
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadLog\"; filename=\"vim_go.gz\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[NSData dataWithData:data]];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [request  setHTTPBody:body];
//    //    [request addValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    
//    
//    //    [[NSURLSession sharedSession] uploadTaskWithStreamedRequest:request];
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
//        
//        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//        NSDictionary *result = [unarchiver decodeObjectForKey:@"ret"];
//        NSNumber *ret = [result objectForKey:@"ret"];
//        
//        if (ret.integerValue==0&&data) {
//            NSLog(@"发送成功%@",result);
//            [SAFileManeger deleteFile:[[SACommon shareInstance] getFilePath]];
//        }
//        else
//        {
//            NSLog(@"发送失败");
//        }
//        
//    }];
//}




@end
