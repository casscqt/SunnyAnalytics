//
//  SANetWork.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/11/17.
//  Copyright © 2015年 gitpark. All rights reserved.
//

#import "SANetWork.h"
#import "SAFileManeger.h"
#import "SACommon.h"

@implementation SANetWork

+ (SANetWork *)sharedInstance{
    static SANetWork *netWork = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        netWork = [[self alloc] init];
    });
    return netWork;
}

-(void)doGetWork:(NSString *)url params:(NSMutableDictionary *)dic {
    //2.构造Request
    //把get请求的请求头保存在request里
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 参数
    // (1)url
    // (2)缓存策略
    // (3)超时的时间, 经过120秒之后就放弃这次请求
    //NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:120];
    //NSURLRequest 不可变,不能动态的添加请求头信息
    
    //可变的对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:url]];
    
    //(1)设置请求方式
    [request setHTTPMethod:@"GET"];
    //(2)超时时间
    [request setTimeoutInterval:50];
    //(3)缓存策略
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    //(4)设置请求头其他内容
    //[request setValue:<#(NSString *)#> forHTTPHeaderField:<#(NSString *)#>];
    //[request addValue:<#(NSString *)#> forHTTPHeaderField:(NSString *)];
    //[request setAllHTTPHeaderFields:<#(NSDictionary *)#>];
//   [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"]; //告诉服务,返回的数据需要压缩
    
    NSURLSession *session = [NSURLSession sharedSession];
    /**
     * task
     *
     * @param data 返回的数据
     * @param response 响应头
     * @param error 错误信息
     *
     */
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"data: %@", dataStr);
        }
    }];
    [task resume];
}


/**
 *  上传文件接口，暂时未启用
 */
-(void)uploadData
{
    //    NSString *fileName = @"hmt";
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    [dic setObject:@"operate" forKey:@"operateType"];
    //    NSArray *arr = @[dic];
    //    [SAFileManeger writeToFile:arr toPath:VIEWINFO_PATH];
    
    //  确定需要上传的文件(假设选择本地的文件)
    NSURL*theurl=[NSURL fileURLWithPath:[[SACommon shareInstance] getFilePath] ];
    NSData *data = [NSData dataWithContentsOfURL:theurl];
    NSURL *url = [NSURL URLWithString:[SACommon shareInstance].baseUrl ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:5.0];
    [request setHTTPMethod:@"POST"];
    
    //    [request setHTTPBody:[data base64EncodedDataWithOptions:NSUTF8StringEncoding]];
    //    [request setValue:@"" forKey:@"Content-Type"];
    //    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadLog\"; filename=\"vim_go.gz\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request  setHTTPBody:body];
    //    [request addValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    
    //    [[NSURLSession sharedSession] uploadTaskWithStreamedRequest:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *result = [unarchiver decodeObjectForKey:@"ret"];
        NSNumber *ret = [result objectForKey:@"ret"];
        
        if (ret.integerValue==0&&data) {
            NSLog(@"发送成功%@",result);
            [SAFileManeger deleteFile:[[SACommon shareInstance] getFilePath]];
        }
        else
        {
            NSLog(@"发送失败");
        }
        
    }];
}




@end
