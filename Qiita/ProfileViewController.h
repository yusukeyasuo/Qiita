//
//  ProfileViewController.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/28.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "Downloader.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DownLoaderDelegate>
{
    NSString *_items;
    NSString *_following;
    NSString *_followers;
    NSString *_name;
    NSDictionary *_jsonObject;
    NSURLConnection *_connection;
    NSMutableData *_jsonData;
    UIRefreshControl *_refreshControl;
    NSMutableDictionary *_imageDict;
    IBOutlet UITableView *_userInfo;
}

@property NSString *name;

@end
