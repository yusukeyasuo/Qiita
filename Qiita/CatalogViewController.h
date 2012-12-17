//
//  CatalogViewController.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/13.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "Downloader.h"

@interface CatalogViewController : UITableViewController <DownLoaderDelegate>
{
    NSString *_page_title;
    NSString *_api_url;
    NSArray *_jsonObject;
    NSURLConnection *_connection;
    NSMutableData *_jsonData;
    UIRefreshControl *_refreshControl;
    NSMutableDictionary *_imageDict;
    int _page;
    int _loading;
}

@property (strong, nonatomic) NSString *page_title;
@property (strong, nonatomic) NSString *api_url;

@end
