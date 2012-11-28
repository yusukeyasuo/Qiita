//
//  NewViewController.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/13.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "NewViewController.h"
#import "WebViewController.h"
#import "QiitaEntryCell.h"
#import "ProfileViewController.h"

@interface NewViewController ()

@end

@implementation NewViewController
@synthesize height = _height;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"新着";
        self.tabBarItem.image = [UIImage imageNamed:@"new"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self searchNewItem];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    // インジケーターの表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.tableView addSubview:_refreshControl];
}

- (void)refresh
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self searchNewItem];
}

- (void) searchNewItem
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://qiita.com/api/v1/items/?page=1&per_page=20"]];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// 非同期通信 ヘッダーが返ってきた
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // データを初期化
    _jsonData = [[NSMutableData alloc] initWithData:0];
}

// 非同期通信 ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // データを追加する
    [_jsonData appendData:data];
}

// 非同期通信 エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_refreshControl endRefreshing];
}

// 非同期通信 ダウンロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSError *error=nil;
    _jsonObject = [NSJSONSerialization JSONObjectWithData:_jsonData options:NSJSONReadingAllowFragments error:&error];
    [_refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//行数を決めるメソッド　※ここでは(mangalist.plist)のitem数をカウントした行数分だけ値を返す。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_jsonObject count];
}

//表示する内容(セル)を答えるメソッド[tableView:cellForRowAtIndexPath:]
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *keyword = [_jsonObject objectAtIndex:indexPath.row];
    NSDictionary *user = [keyword objectForKey:@"user"];
    QiitaEntryCell *cell = (QiitaEntryCell *)[tableView dequeueReusableCellWithIdentifier:@"QiitaEntryCell"];
    
    if (!cell) {
        cell = [[QiitaEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QiitaEntryCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *imageURL = [user objectForKey:@"profile_image_url"];
    cell.profileImage.layer.cornerRadius = 4.0;
    cell.profileImage.clipsToBounds = YES;
    //[cell.profileImage loadImage:imageURL];
    
    NSString *tmp = [keyword objectForKey:@"title"];
    CGSize labelSize = [tmp sizeWithFont:[UIFont systemFontOfSize:15]
                       constrainedToSize:CGSizeMake(250, 1000)
                           lineBreakMode:NSLineBreakByWordWrapping];
    cell.titleLabel.frame = CGRectMake(40.0, 23.0, 250.0, labelSize.height);
    cell.titleLabel.text = [keyword objectForKey:@"title"];
    
    cell.createdLabel.frame = CGRectMake(40.0, 27.0+labelSize.height, 250.0, 15.0);
    cell.createdLabel.text = [keyword objectForKey:@"created_at"];
    
    cell.urlnameLabel.text = [user objectForKey:@"url_name"];
    cell.urlnameLabel.userInteractionEnabled = YES;
    [cell.urlnameLabel addGestureRecognizer:
     [[UITapGestureRecognizer alloc]
      initWithTarget:self action:@selector(leftAction:)]];
    
        return cell;
}

- (void)leftAction: (UITapGestureRecognizer *)sender{
    CGPoint pos = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pos];
    NSDictionary *keyword = [_jsonObject objectAtIndex:indexPath.row];
    NSDictionary *user = [keyword objectForKey:@"user"];
    
    ProfileViewController *profileController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profileController.name = [user objectForKey:@"url_name"];
    [self.navigationController pushViewController:profileController animated:YES];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *keyword = [_jsonObject objectAtIndex:indexPath.row];
    NSString *tmp = [keyword objectForKey:@"title"];
    CGSize labelSize = [tmp sizeWithFont:[UIFont systemFontOfSize:15]
                       constrainedToSize:CGSizeMake(254, 1000)
                           lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height + 45.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dics = [_jsonObject objectAtIndex:indexPath.row];
    NSString *url = [dics objectForKey:@"url"];
    NSString *pageTitle = [dics objectForKey:@"title"];
    
    WebViewController *webController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webController._webItem = url;
    webController.pageTitle = pageTitle;
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
