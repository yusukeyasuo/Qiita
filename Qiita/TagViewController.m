//
//  TagViewController.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/13.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "TagViewController.h"
#import "CatalogViewController.h"
#import "QiitaTagCell.h"
#import "PostViewController.h"

@interface TagViewController ()

@end

@implementation TagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"タグ";
        self.tabBarItem.image = [UIImage imageNamed:@"tag"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    _imageDict = [[NSMutableDictionary alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self searchTab];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [showTab addSubview:_refreshControl];
    
    // 投稿ボタンの表示
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                target:self
                                                                                action:@selector(post_entry)];
    [self.navigationItem setRightBarButtonItem:postButton animated:YES];

}

- (void)post_entry
{
    UIViewController *postController = [[PostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:postController];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)refresh
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self searchTab];
}

- (void)searchTab
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://qiita.com/api/v1/tags/"]];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// 非同期通信 ヘッダーが返ってきた
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // データを初期化
    _jsonData = [[NSMutableData alloc] initWithData:0];
    // インジケーターの表示
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
    [_refreshControl endRefreshing];
    NSError *error=nil;
    _jsonObject = [NSJSONSerialization JSONObjectWithData:_jsonData options:NSJSONReadingAllowFragments error:&error];
    [showTab reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloaderDidFinish:(Downloader *)downloader
{
    [_imageDict setObject:downloader.data forKey:downloader.indexPath];
    [showTab reloadData];
}

- (void)downloaderDidFailed:(Downloader *)downloader withError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:error.localizedDescription
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_jsonObject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tagDict = [_jsonObject objectAtIndex:indexPath.row];
    QiitaTagCell *cell = (QiitaTagCell *)[tableView dequeueReusableCellWithIdentifier:@"QiitaTagCell"];
    
    if (!cell) {
        cell = [[QiitaTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QiitaTagCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    NSString *imageURL = [tagDict objectForKey:@"icon_url"];
    NSData *data = [_imageDict objectForKey:indexPath];
    if (data) {
        cell.tagImage.image = [UIImage imageWithData:data];
    } else {
        Downloader *downloader = [[Downloader alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]] withIndexPath:indexPath];
        downloader.delegate = self;
        [downloader start];
        cell.tagImage.image = [UIImage imageNamed:@"QiitaTable.png"];
    }
    
    cell.tagImage.layer.cornerRadius = 4.0;
    cell.tagImage.clipsToBounds = YES;

    cell.tagNameLabel.text = [tagDict objectForKey:@"name"];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CatalogViewController *catalogController = [[CatalogViewController alloc] initWithNibName:@"CatalogViewController" bundle:nil];
    NSDictionary *tagDict = [_jsonObject objectAtIndex:indexPath.row];
    catalogController.searchWord = [tagDict objectForKey:@"name"];
     [self.navigationController pushViewController:catalogController animated:YES];
}

@end

