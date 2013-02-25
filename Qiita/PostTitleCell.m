//
//  PostTitleCell.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/12/18.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "PostTitleCell.h"

@implementation PostTitleCell
@synthesize titleField = _titleField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
