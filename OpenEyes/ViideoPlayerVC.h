//
//  ViideoPlayerVC.h
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/25.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViideoPlayerVC : UIViewController

@property (nonatomic,copy) NSString * urlStr;
@property (nonatomic,copy) NSString * titleStr;
@property (nonatomic,assign) double  duration;

@end
