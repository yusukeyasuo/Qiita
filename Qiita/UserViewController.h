//
//  UserViewController.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/12/04.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Downloader.h"

@interface UserViewController : UITableViewController <DownLoaderDelegate>
{
    NSMutableDictionary *_imageDict;
    NSArray *_jsonObject;
    NSURLConnection *_connection;
    NSMutableData *_jsonData;
    UIRefreshControl *_refreshControl;
    NSString *_name;
    NSString *_api_url;
    int _page;
    int _loading;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *api_url;

@end
