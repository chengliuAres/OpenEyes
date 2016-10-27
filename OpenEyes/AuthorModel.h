//
//  AuthorModel.h
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/25.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorModel : NSObject

// icon
@property (nonatomic, copy) NSString *iconImage;
// 作者
@property (nonatomic, copy) NSString *authorLabel;
// 视频数量
@property (nonatomic, copy) NSString *videoCount;
// 简介
@property (nonatomic, copy) NSString *desLabel;
// ID
@property (nonatomic, copy) NSString *authorId;
// actionUrl
@property (nonatomic, copy) NSString *actionUrl;

@end
