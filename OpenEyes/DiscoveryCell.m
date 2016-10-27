//
//  DiscoveryCell.m
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/26.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "DiscoveryCell.h"

@implementation DiscoveryCell

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        _ImageView =[[UIImageView alloc]initWithFrame:self.bounds];
        _ImageView.backgroundColor =[UIColor grayColor];
        [self.contentView addSubview:_ImageView];
        
        _shadeView =[[UIImageView alloc] initWithFrame:self.bounds];
        _shadeView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:_shadeView];
        
        _title =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
        _title.textAlignment =NSTextAlignmentCenter;
        _title.textColor =[UIColor whiteColor];
        _title.center = self.contentView.center;
        _title.font =[UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
        [self.contentView addSubview:_title];
    }
    return self;
}
@end
