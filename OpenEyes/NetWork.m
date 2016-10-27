//
//  NetWork.m
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/24.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "NetWork.h"

@implementation NetWork

+(AFHTTPSessionManager *)initAFHttpManager{
    static AFHTTPSessionManager * manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager =[AFHTTPSessionManager manager];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        
    });
    return manager;
}
+(void)requestDataByUrl:(NSString *)urlPath Parameters:(NSDictionary *)params success:(CallBackBlock)success failBlock:(CallBackBlock)fail{
    AFHTTPSessionManager * manager =[NetWork initAFHttpManager];
    [manager GET:urlPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error.localizedDescription);
    }];
}
@end
