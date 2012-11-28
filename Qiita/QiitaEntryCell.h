//
//  QiitaEntryCell.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/21.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiitaEntryCell : UITableViewCell
{
    UIImageView *_profileImage;
    UILabel *_urlnameLabel;
    UILabel *_titleLabel;
    UILabel *_createdLabel;
}

@property (nonatomic, strong) UILabel *urlnameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *createdLabel;
@property (nonatomic, strong) UIImageView *profileImage;

@end
