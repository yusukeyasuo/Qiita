//
//  WebViewController.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/13.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "WebViewController.h"
#import "SaveToken.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize _webItem;
@synthesize pageTitle;
@synthesize uuid = _uuid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // ツールバーを表示
    [self.navigationController setToolbarHidden:NO animated:NO];
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    
    // 戻る、進む、更新、シェアボタンの表示
    _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back2.png"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(goBack)];

    _forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward2.png"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(goForward)];
    
    _reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                  target:self
                                                                  action:@selector(reload)];
    
    _shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                 target:self
                                                                 action:@selector(showActionSheet)];
    
    UIBarButtonItem *gap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                         target:nil
                                                                         action:nil];
    
    NSArray *items = @[gap, _backButton, gap, _forwardButton, gap, _reloadButton, gap, _shareButton, gap];
    self.toolbarItems = items;
    
    self.title = [NSString stringWithFormat:@"%@", pageTitle];
    // Do any additional setup after loading the view from its nib.
    NSURL * url = [[NSURL alloc] initWithString:_webItem];
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:url];
    [_webview loadRequest:req];
    
    // シェア方法を選択
    _shareItems = @[@"投稿をストック", @"Twitterに投稿", @"Facebookに投稿", @"Safariで開く"];
}

- (void)showActionSheet
{
    _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *title in _shareItems)
    {
        [_actionSheet addButtonWithTitle:title];
    }
    _actionSheet.cancelButtonIndex = [_actionSheet addButtonWithTitle:@"キャンセル"];
    [_actionSheet showFromToolbar:self.navigationController.toolbar];
}

// UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *sharestr = [NSString stringWithFormat:@"%@ #Qiita", pageTitle];
    if (buttonIndex == 0) {
        NSString *urlstr = [[NSString alloc] initWithFormat:@"https://qiita.com/api/v1/items/%@/stock?token=%@", _uuid, [SaveToken sharedManager].current_token];
        NSURL *url = [NSURL URLWithString:urlstr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
        [request setHTTPMethod: @"PUT"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        
        // インジケーターを表示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    } else if (buttonIndex == 1) {
        SLComposeViewController *slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [slComposeViewController setInitialText:sharestr];
        [slComposeViewController addURL:[NSURL URLWithString:_webItem]];
        [self presentViewController:slComposeViewController animated:YES completion:nil];
    } else if (buttonIndex == 2) {
        SLComposeViewController *slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposeViewController setInitialText:sharestr];
        [slComposeViewController addURL:[NSURL URLWithString:_webItem]];
        [self presentViewController:slComposeViewController animated:YES completion:nil];
    } else if (buttonIndex == 3) {
        NSURL *safari = [NSURL URLWithString:_webItem];
        [[UIApplication sharedApplication] openURL:safari];
    }
}

// 非同期通信 ヘッダーが返ってきた
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // データを初期化
    _json_data = [[NSMutableData alloc] initWithData:0];
}

// 非同期通信 ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // データを追加する
    [_json_data appendData:data];
}

// 非同期通信 エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"Error");
}

// 非同期通信 ダウンロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)goBack {
    [_webview goBack];
}

- (void)goForward {
    [_webview goForward];
}

- (void)reload
{
    [_webview reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    _indicator.hidden = NO;
    [_indicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_indicator stopAnimating];
    _indicator.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _backButton.enabled = webView.canGoBack;
    _forwardButton.enabled = webView.canGoForward;
    
    if (webView.canGoBack) {
        [_backButton setImage:[UIImage imageNamed:@"back.png"]];
    }
    
    if (webView.canGoForward) {
        [_forwardButton setImage:[UIImage imageNamed:@"forward.png"]];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


@end
