//
//  UINavigationBar+bgColor.m
//  导航栏背景颜色
//
//  Created by AppleCheng on 16/4/25.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "UINavigationBar+bgColor.h"
#import <objc/runtime.h>
@implementation UINavigationBar (bgColor)
static char alView;
-(void)setAlphaView:(UIView *)alphaView{
    objc_setAssociatedObject(self, &alView, alphaView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIView *)alphaView{
    return objc_getAssociatedObject(self, &alView);
}
-(void)alphaNavigationBarView:(UIColor *)color{
    if (!self.alphaView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.alphaView =[[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        [self insertSubview:self.alphaView atIndex:0];
    }
    [self.alphaView setBackgroundColor:color];
}
-(void)removeAlphaInsteadWithColor:(UIColor *)color{
    //[self.alphaView removeFromSuperview];
    self.alphaView.hidden =YES;
    self.translucent =NO;
    [self setTintColor:[UIColor whiteColor]];
    [self setBarTintColor:color];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
-(void)showAlphaView{
    self.alphaView.hidden =NO;
    self.translucent =YES;
}
-(void)setDefaultNav{
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setBackgroundImage:[UIImage imageNamed:@"accent.jpg"] forBarMetrics:UIBarMetricsDefault];
    [self setTintColor:[UIColor whiteColor]];
}
@end
