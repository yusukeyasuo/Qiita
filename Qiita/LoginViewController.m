//
//  LoginViewController.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/11/24.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "LoginViewController.h"
#import "SaveToken.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"ログイン";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.392 green:0.788 blue:0.078 alpha:1]; 
    
    // Qiitaアイコンの表示
    UIImage *img = [UIImage imageNamed:@"Qiita.png"];
    _qiita_icon.layer.cornerRadius = 4.0;
    _qiita_icon.clipsToBounds = YES;
    _qiita_icon.image = img;
    
    [_username becomeFirstResponder];
    
    // キャンセルボタンの表示
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancel)];
    [self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
}

// キャンセルボタンを押したときの処理
- (void)cancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushLogin:(id)sender {
    NSString *post_data = [NSString stringWithFormat:@"url_name=%@&password=%@", _username.text, _password.text];
    NSURL *url = [NSURL URLWithString:@"https://qiita.com/api/v1/auth"];
    NSData *request_data = [post_data dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: request_data];
    
    // インジケーターを表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
    NSError *error=nil;
    _json_object = [NSJSONSerialization JSONObjectWithData:_json_data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"response: %@", _json_object);
    //NSLog(@"token: %@", [_json_object objectForKey:@"token"]);
    if (![_json_object objectForKey:@"error"]) {
        NSLog(@"token: %@", [_json_object objectForKey:@"token"]);
        [[SaveToken sharedManager] add_token:[_json_object objectForKey:@"token"] add_url_name:[_json_object objectForKey:@"url_name"]];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[_json_object objectForKey:@"error"]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }

}

@end
