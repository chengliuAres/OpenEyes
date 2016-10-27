//
//  NetWork.h
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/24.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"
typedef void (^CallBackBlock)(id responseObj);

@interface NetWork : NSObject

@property (nonatomic,copy) CallBackBlock successCall;
@property (nonatomic,copy) CallBackBlock DeaultCall;
+(void)requestDataByUrl:(NSString *)urlPath Parameters:(NSDictionary *)params success:(CallBackBlock)success failBlock:(CallBackBlock)fail;
@end
