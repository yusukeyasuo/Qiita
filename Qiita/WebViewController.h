//
//  WebViewController.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/13.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *_indicator;
    UIBarButtonItem *_indicatorButton;
    UIBarButtonItem *_refreshButton;
}

@property NSString* _webItem;
@property NSString* pageTitle;

@end
