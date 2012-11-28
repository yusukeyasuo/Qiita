//
//  HomeViewController.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/11/24.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "Downloader.h"


@interface HomeViewController : UITableViewController <NSURLConnectionDataDelegate, DownLoaderDelegate>
{
    NSMutableArray *_jsonObject;
    NSURLConnection *_connection;
    NSMutableData *_jsonData;
    UIRefreshControl *_refreshControl;
    NSMutableDictionary *_imageDict;
    int _page;
    int _loading;
}


@end
