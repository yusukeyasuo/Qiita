//
//  NewViewController.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/13.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

@interface NewViewController : UITableViewController
{
    NSArray *_jsonObject;
    NSURLConnection *_connection;
    NSMutableData *_jsonData;
    UIRefreshControl *_refreshControl;
    int _height;
}

@property (readwrite) int height;

@end
