//
//  TagViewController.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/13.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Downloader.h"

@interface TagViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, DownLoaderDelegate>
{
    IBOutlet UITableView *showTab;
    NSMutableDictionary *_imageDict;
    NSArray *_jsonObject;
    NSURLConnection *_connection;
    NSMutableData *_jsonData;
    UIRefreshControl *_refreshControl;
}

@end
