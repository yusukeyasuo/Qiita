//
//  QiitaEntryCell.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/21.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "QiitaEntryCell.h"

@implementation QiitaEntryCell
@synthesize profileImage = _profileImage;
@synthesize urlnameLabel = _urlnameLabel;
@synthesize titleLabel = _titleLabel;
@synthesize createdLabel = _createdLabel;
@synthesize tagLabel = _tagLabel;
@synthesize tag2Label = _tag2Label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    // profileImageの作成
    _profileImage = [[UIImageView alloc] init];
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
    
    // tagLabelの作成
    _tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _tagLabel.font = [UIFont systemFontOfSize:15.0f];
    _tagLabel.textColor = [UIColor whiteColor];
    _tagLabel.highlightedTextColor = [UIColor whiteColor];
    _tagLabel.backgroundColor = [UIColor lightGrayColor];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    [[_tagLabel layer] setCornerRadius:4.0];
    [_tagLabel setClipsToBounds:YES];
    [self.contentView addSubview:_tagLabel];
    
    // tag2Labelの作成
    _tag2Label = [[UILabel alloc] initWithFrame:CGRectZero];
    _tag2Label.font = [UIFont systemFontOfSize:15.0f];
    _tag2Label.textColor = [UIColor whiteColor];
    _tag2Label.highlightedTextColor = [UIColor whiteColor];
    _tag2Label.backgroundColor = [UIColor lightGrayColor];
    _tag2Label.textAlignment = NSTextAlignmentCenter;
    [[_tag2Label layer] setCornerRadius:4.0];
    [_tag2Label setClipsToBounds:YES];
    [self.contentView addSubview:_tag2Label];
    
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
    
    // titleLabelのレイアウト
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
}


@end
