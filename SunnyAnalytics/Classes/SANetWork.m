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

#define SERVER_PATH @"http://172.16.30.15:8080/actionDetail/collect.do"

@implementation SANetWork

+ (SANetWork *)sharedInstance{
    static SANetWork *netWork = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        netWork = [[self alloc] init];
    });
    return netWork;
}

-(void)doGetWork:(NSMutableDictionary *)dic {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:50];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager GET:SERVER_PATH parameters:dic success:^(NSURLSessionDataTask *task, id responseObject){

    } failure:^(NSURLSessionDataTask *task, NSError *error){

    }];
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
