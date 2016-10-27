//
//  NiceChoiceCell.m
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/24.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "NiceChoiceCell.h"

@implementation NiceChoiceCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView * image =[[UIImageView alloc]init];
        [self.contentView addSubview:image];
        _ImageView = image;
        
        UIImageView * shadeView =[[UIImageView alloc] init];
        shadeView.backgroundColor =[UIColor colorWithDisplayP3Red:0 green:0 blue:0 alpha:0.4];
        self.shadeView = shadeView;
        [self.contentView addSubview:self.shadeView];
        
        UILabel * title =[[UILabel alloc] init];
        title.textColor =[UIColor whiteColor];
        title.font =[UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:title];
        _titleLabel = title;
        
        UILabel * message =[[UILabel alloc] init];
        message.textColor =[UIColor whiteColor];
        message.font =[UIFont systemFontOfSize:12];
        message.textAlignment =NSTextAlignmentCenter;
        [self.contentView addSubview:message];
        self.messageLabel = message;
        
    }
    return self;
}
//设置所有的的子空间的frame
-(void)layoutSubviews{
    [super layoutSubviews];
    _ImageView.frame =self.bounds ;
    _shadeView.frame = self.bounds;
    _titleLabel.frame = CGRectMake(5, self.bounds.size.height/2-20, self.bounds.size.width-10, 30);
    _messageLabel.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame)+5, _titleLabel.frame.size.width, 25);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
