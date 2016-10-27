//
//  AuthorDetailVC.h
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/25.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorDetailVC : UIViewController


@property (nonatomic, copy) NSString *authorId;

// 作者信息
@property (nonatomic, copy) NSString *authorName;

@property (nonatomic, copy) NSString *authorDesc;

@property (nonatomic, copy) NSString *authorIcon;


@end
