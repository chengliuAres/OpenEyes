//
//  UINavigationBar+bgColor.h
//  导航栏背景颜色
//
//  Created by AppleCheng on 16/4/25.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (bgColor)

@property (nonatomic,strong) UIView * alphaView;
-(void)alphaNavigationBarView:(UIColor *)color;
-(void)removeAlphaInsteadWithColor:(UIColor *)color;
-(void)showAlphaView;
-(void)setDefaultNav;
@end
