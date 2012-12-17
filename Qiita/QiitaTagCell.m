//
//  QiitaTagCell.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/29.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "QiitaTagCell.h"

@implementation QiitaTagCell
@synthesize tagImage = _tagImage;
@synthesize tagNameLabel = _tagNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    // tagImageの作成
    UIImage *image = [UIImage imageNamed:@"QiitaTable.png"];
    _tagImage = [[UIImageView alloc] initWithImage:image];
    [[_tagImage layer] setCornerRadius:4.0];
    [_tagImage setClipsToBounds:YES];
    [self.contentView addSubview:_tagImage];
    
    // tagNameLabelの作成
    _tagNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _tagNameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    _tagNameLabel.textColor = [UIColor blackColor];
    _tagNameLabel.highlightedTextColor = [UIColor whiteColor];
    _tagNameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_tagNameLabel];
    
    return self;
}

- (void)layoutSubviews
{
    CGRect  rect;
    
    // 親クラスのメソッドを呼び出す
    [super layoutSubviews];
    
    // profileImageのrect.origin = CGPointZero;
    rect = CGRectMake(9.0f, 9.0f, 25.0f, 25.0f);
    _tagImage.frame = rect;
    
    // contentViewの大きさを取得する
    CGRect  bounds;
    bounds = self.contentView.bounds;
    
    // urlnameLabelのレイアウト
    rect.origin.x = 47.0f;
    rect.origin.y = 0.0f;
    rect.size.width = 230.0f;
    rect.size.height = 43.0f;
    _tagNameLabel.frame = rect;
}

@end
