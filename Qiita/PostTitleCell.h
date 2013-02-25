//
//  PostTitleCell.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/12/18.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTitleCell : UITableViewCell
{
    IBOutlet UITextField *_titleField;
}

@property (nonatomic, strong)UITextField *titleField;

@end
