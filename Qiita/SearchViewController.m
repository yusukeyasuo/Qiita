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
#import "FollowingTag.h"

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
    _loading = 1;
	// Do any additional setup after loading the view, typically from a nib.
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

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:NO];
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

// 1ページ目を読み込む
- (void)searchWord:(NSString *)string
{
    _reqestURL = [NSString stringWithFormat:@"https://qiita.com/api/v1/search?q=%@&page=1&per_page=20", string];
    _request = [NSURLRequest requestWithURL:[NSURL URLWithString:_reqestURL]];
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
    _page = 1;
    _imageDict = [[NSMutableDictionary alloc] init];
}

// 続きを読み込む
- (void)add_row:(NSString *)string
{
    _page++;
    NSString *url = [NSString stringWithFormat:@"https://qiita.com/api/v1/search?q=%@&page=%d&per_page=20", string, _page];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
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
    if (_page == 1) {
        // 1ページ目の処理
        _jsonObject = [NSJSONSerialization JSONObjectWithData:_jsonData options:NSJSONReadingAllowFragments error:&error];;
        [_refreshControl endRefreshing];
    } else {
        // 2ページ目以降の処理
        NSArray *jo = [[NSArray alloc] init];
        jo = [NSJSONSerialization JSONObjectWithData:_jsonData options:NSJSONReadingAllowFragments error:&error];
        NSMutableArray *ma = [[NSMutableArray alloc] init];
        for (NSDictionary* i in _jsonObject) {
            [ma addObject:i];
        }
        for (NSDictionary* i in jo) {
            [ma addObject:i];
        }
        _jsonObject = [[NSMutableArray alloc] init];
        _jsonObject = ma;
        _loading = 1;
    }
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
    NSLog(@"%@", error);
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
    
    CGSize urlnameLabelSize = [[user objectForKey:@"url_name"] sizeWithFont:[UIFont systemFontOfSize:15]
                                                          constrainedToSize:CGSizeMake(250, 1000)
                                                              lineBreakMode:NSLineBreakByWordWrapping];
    cell.urlnameLabel.frame = CGRectMake(40.0, 4.0, urlnameLabelSize.width + 15.0, 16.0);
    cell.urlnameLabel.text = [user objectForKey:@"url_name"];
    cell.urlnameLabel.userInteractionEnabled = YES;
    [cell.urlnameLabel addGestureRecognizer:
     [[UITapGestureRecognizer alloc]
      initWithTarget:self action:@selector(leftAction:)]];
    
    NSArray *tags = [keyword objectForKey:@"tags"];
    BOOL flg = false;
    for (NSDictionary *dict in [FollowingTag sharedManager].tags) {
        if ([[[tags objectAtIndex:0] objectForKey:@"name"] isEqualToString:[dict objectForKey:@"name"]]) {
            flg = true;
        }
    }
    CGSize tagLabelSize = [[[tags objectAtIndex:0] objectForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:15]
                                                                    constrainedToSize:CGSizeMake(250, 1000)
                                                                        lineBreakMode:NSLineBreakByWordWrapping];
    cell.tagLabel.frame = CGRectMake(cell.urlnameLabel.frame.origin.x + cell.urlnameLabel.frame.size.width, 4.0, tagLabelSize.width + 10.0, 16.0);
    cell.tagLabel.text = [[tags objectAtIndex:0] objectForKey:@"name"];
    if (flg) {
        cell.tagLabel.backgroundColor = [UIColor colorWithRed:0.392 green:0.788 blue:0.078 alpha:1];
    } else {
        cell.tagLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    if (tags.count > 1) {
        BOOL flg = false;
        for (NSDictionary *dict in [FollowingTag sharedManager].tags) {
            if ([[[tags objectAtIndex:1] objectForKey:@"name"] isEqualToString:[dict objectForKey:@"name"]]) {
                flg = true;
            }
        }
        CGSize tag2LabelSize = [[[tags objectAtIndex:1] objectForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:15]
                                                                         constrainedToSize:CGSizeMake(250, 1000)
                                                                             lineBreakMode:NSLineBreakByWordWrapping];
        cell.tag2Label.frame = CGRectMake(cell.tagLabel.frame.origin.x + cell.tagLabel.frame.size.width + 10.0, 4.0, tag2LabelSize.width + 10.0, 16.0);
        cell.tag2Label.text = [[tags objectAtIndex:1] objectForKey:@"name"];
        if (flg) {
            cell.tag2Label.backgroundColor = [UIColor colorWithRed:0.392 green:0.788 blue:0.078 alpha:1];
        } else {
            cell.tag2Label.backgroundColor = [UIColor lightGrayColor];
        }
    } else {
        cell.tag2Label.text = @"";
        cell.tag2Label.backgroundColor = [UIColor clearColor];
    }

    if (indexPath.row == (_page * 20 - 1) && _loading == 1) {
        [self add_row:_saveSearchWord];
        _loading = 0;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }

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
    NSString *uuid = [dics objectForKey:@"uuid"];
    
    WebViewController *webController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webController._webItem = url;
    webController.pageTitle = pageTitle;
    webController.uuid = uuid;
    webController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webController animated:YES];

    
}


@end
