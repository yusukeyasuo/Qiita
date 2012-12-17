//
//  QiitaTagCell.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/29.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface QiitaTagCell : UITableViewCell
{
    UIImageView *_tagImage;
    UILabel *_tagNameLabel;
}

@property (strong, nonatomic)UILabel *tagNameLabel;
@property (strong, nonatomic)UIImageView *tagImage;

@end
