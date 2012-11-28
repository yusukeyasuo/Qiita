//
//  SearchViewController.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/13.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "Downloader.h"

@interface SearchViewController : UIViewController <UISearchBarDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, DownLoaderDelegate>
{
    UISearchBar *_searchWord;
    IBOutlet UITableView *_showWord;
    NSArray *_jsonObject;
    NSURLConnection *_connection;
    NSMutableData *_jsonData;
    UIRefreshControl *_refreshControl;
    NSURLRequest *_request;
    NSString *_reqestURL;
    NSString *_saveSearchWord;
    NSMutableDictionary *_imageDict;
}

@end
