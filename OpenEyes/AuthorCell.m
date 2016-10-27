//
//  AuthorCell.m
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/25.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "AuthorCell.h"

@implementation AuthorCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView * image =[[UIImageView alloc] init];
        [self.contentView addSubview:image];
        self.iconImage = image;
        
        UILabel * author =[[UILabel alloc] init];
        author.textColor =[UIColor blackColor];
        author.font = [UIFont systemFontOfSize:14];
        author.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:author];
        _authorLabel = author;
        
        UILabel * videoCount =[[UILabel alloc] init];
        videoCount.textColor =[UIColor darkGrayColor];
        videoCount.font =[UIFont systemFontOfSize:10];
        videoCount.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:videoCount] ;
        _authorLabel = videoCount;
        
        UILabel * des =[[UILabel alloc] init];
        des.textColor =[UIColor darkGrayColor];
        des.font =[UIFont systemFontOfSize:10];
        des.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:des];
        self.desLabel = des;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _iconImage.frame = CGRectMake(10, 15, 40, 40);
    _iconImage.layer.cornerRadius =20;
    _iconImage.layer.masksToBounds =YES;
    self.authorLabel.frame =CGRectMake(60, 15, self.contentView.frame.size.width-100, 20);
    self.desLabel.frame = CGRectMake(60, 15+20+5, self.bounds.size.width-90, 20);
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
