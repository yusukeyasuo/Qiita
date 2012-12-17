//
//  WebViewController.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/13.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UIWebView *_webview;
    IBOutlet UIActivityIndicatorView *_indicator;
    UIBarButtonItem *_indicatorButton;
    UIBarButtonItem *_refreshButton;
    UIBarButtonItem *_backButton;
    UIBarButtonItem *_forwardButton;
    UIBarButtonItem *_reloadButton;
    UIBarButtonItem *_shareButton;
    NSArray *_shareItems;
    UIActionSheet *_actionSheet;
    NSURLConnection *_connection;
    NSString *_uuid;
    NSMutableData *_json_data;
}

@property NSString* _webItem;
@property NSString* pageTitle;
@property NSString* uuid;

@end
