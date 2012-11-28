//
//  QiitaEntryCell.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/21.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "QiitaEntryCell.h"

@implementation QiitaEntryCell
@synthesize urlnameLabel = _urlnameLabel;
@synthesize titleLabel = _titleLabel;
@synthesize createdLabel = _createdLabel;
@synthesize profileImage = _profileImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    // profileImageの作成
    UIImage *image = [UIImage imageNamed:@"QiitaTable.png"];
    //_profileImage = [[UIAsyncImageView alloc] initWithImage:image];
    _profileImage = [[UIImageView alloc] initWithImage:image];
    [self.contentView addSubview:_profileImage];
    
    // urlnameLabelの作成
    _urlnameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _urlnameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _urlnameLabel.textColor = [UIColor blackColor];
    _urlnameLabel.textColor = [UIColor colorWithRed:0 green:0.2 blue:0.4 alpha:1];
    _urlnameLabel.highlightedTextColor = [UIColor whiteColor];
    _urlnameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_urlnameLabel];
    
    // titlenameLabelの作成
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.highlightedTextColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_titleLabel];
    
    // createdLabelの作成
    _createdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createdLabel.font = [UIFont systemFontOfSize:15.0f];
    _createdLabel.textColor = [UIColor darkGrayColor];
    _createdLabel.highlightedTextColor = [UIColor whiteColor];
    _createdLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_createdLabel];
    
    return self;
}

- (void)layoutSubviews
{
    CGRect  rect;
    
    // 親クラスのメソッドを呼び出す
    [super layoutSubviews];
    
    // profileImageのrect.origin = CGPointZero;
    rect = CGRectMake(4.0f, 4.0f, 28.0f, 28.0f);
    _profileImage.frame = rect;
    
    // contentViewの大きさを取得する
    CGRect  bounds;
    bounds = self.contentView.bounds;
    
    // urlnameLabelのレイアウト
    rect.origin.x = 40.0f;
    rect.origin.y = 4.0f;
    rect.size.width = 250.0f;
    rect.size.height = 16.0f;
    _urlnameLabel.frame = rect;
    
    // titleLabelのレイアウト
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
    
    // createdLabelのレイアウト
    /*rect.origin.x = 36.0f;
    rect.origin.y = CGRectGetMaxY(_titleLabel.frame) + 4.0f;
    rect.size.width = 254.0f;
    rect.size.height = 12.0f;
    _titleLabel.frame = rect;*/
}


@end
