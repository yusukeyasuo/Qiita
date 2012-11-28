//
//  SearchViewController.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/13.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "SearchViewController.h"
#import "WebViewController.h"
#import "QiitaEntryCell.h"
#import "ProfileViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"検索";
        self.tabBarItem.image = [UIImage imageNamed:@"search"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _imageDict = [[NSMutableDictionary alloc] init];
    _searchWord = [[UISearchBar alloc] init];
    _searchWord.delegate = self;
    _searchWord.tintColor = [UIColor colorWithRed:0.392 green:0.788 blue:0.078 alpha:1];
    self.navigationItem.titleView = _searchWord;
    self.navigationItem.titleView.frame = CGRectMake(0, 0, 320, 44);
    _searchWord.placeholder = @"Qiitaで検索";
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_showWord addSubview:_refreshControl];
    
}

- (void)refresh
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self searchWord:_saveSearchWord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 検索
- (void)searchWord:(NSString *)string
{
    _reqestURL = [NSString stringWithFormat:@"https://qiita.com/api/v1/search?q=%@&page=1&per_page=20", string];
    _request = [NSURLRequest requestWithURL:[NSURL URLWithString:_reqestURL]];
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
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
    [_showWord reloadData];
}

// サーチバーの検索ボタン押下時
-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [_searchWord resignFirstResponder];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _saveSearchWord = _searchWord.text;
    [self searchWord:_saveSearchWord];

}

- (void)downloaderDidFinish:(Downloader *)downloader
{
    [_imageDict setObject:downloader.data forKey:downloader.indexPath];
    [_showWord reloadData];
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
    NSDictionary *keyword = [_jsonObject objectAtIndex:indexPath.row];
    NSDictionary *user = [keyword objectForKey:@"user"];
    QiitaEntryCell *cell = (QiitaEntryCell *)[tableView dequeueReusableCellWithIdentifier:@"QiitaEntryCell"];
    
    if (!cell) {
        cell = [[QiitaEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QiitaEntryCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *imageURL = [user objectForKey:@"profile_image_url"];
    NSData *data = [_imageDict objectForKey:indexPath];
    if (data) {
        cell.profileImage.image = [UIImage imageWithData:data];
    } else {
        Downloader *downloader = [[Downloader alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]] withIndexPath:indexPath];
        downloader.delegate = self;
        [downloader start];
        cell.profileImage.image = [UIImage imageNamed:@"QiitaTable.png"];
    }
    
    cell.profileImage.layer.cornerRadius = 4.0;
    cell.profileImage.clipsToBounds = YES;
    /*
     [cell.profileImage loadImage:imageURL];
     */
    
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
    CGPoint pos = [sender locationInView:_showWord];
    NSIndexPath *indexPath = [_showWord indexPathForRowAtPoint:pos];
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
                       constrainedToSize:CGSizeMake(250, 1000)
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
    
    NSDictionary *dics = [_jsonObject objectAtIndex:indexPath.row];
    NSString *url = [dics objectForKey:@"url"];
    NSString *pageTitle = [dics objectForKey:@"title"];
    
    WebViewController *webController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webController._webItem = url;
    webController.pageTitle = pageTitle;
    [self.navigationController pushViewController:webController animated:YES];

    
}


@end
