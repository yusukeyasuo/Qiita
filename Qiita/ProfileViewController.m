//
//  ProfileViewController.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/28.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "ProfileViewController.h"
#import "QiitaEntryCell.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize name = _name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _imageDict = [[NSMutableDictionary alloc] init];
    self.title = _name;
    _items = @"";
    _following = @"";
    _followers = @"";
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self searchUserInfo];
}

- (void)refresh
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self searchUserInfo];
}

- (void)searchUserInfo
{
    NSString *req = [NSString stringWithFormat:@"https://qiita.com/api/v1/users/%@/", _name];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:req]];
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
    _items = [_jsonObject objectForKey:@"items"];
    _following = [_jsonObject objectForKey:@"following_users"];
    _followers = [_jsonObject objectForKey:@"followers"];
    [_userInfo reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloaderDidFinish:(Downloader *)downloader
{
    [_imageDict setObject:downloader.data forKey:downloader.indexPath];
    [_userInfo reloadData];
}

- (void)downloaderDidFailed:(Downloader *)downloader withError:(NSError *)error
{
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        QiitaEntryCell *cell = (QiitaEntryCell *)[tableView dequeueReusableCellWithIdentifier:@"QiitaEntryCell"];
        if (!cell) {
            cell = [[QiitaEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QiitaEntryCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSString *tmp = [_jsonObject objectForKey:@"description"];
        tmp = [NSString stringWithFormat:@"%@", tmp];
        if (tmp == nil || [tmp isEqualToString:@"<null>"]) {
            cell.titleLabel.frame = CGRectMake(40.0, 24.0, 250.0, 13.0);
            cell.createdLabel.frame = CGRectMake(40.0, 33.0, 250.0, 0);
        } else {
            CGSize labelSize = [tmp sizeWithFont:[UIFont systemFontOfSize:15]
                               constrainedToSize:CGSizeMake(250, 100)
                                   lineBreakMode:NSLineBreakByWordWrapping];
            cell.titleLabel.frame = CGRectMake(40.0, 24.0, 250.0, labelSize.height);
            cell.titleLabel.text = [_jsonObject objectForKey:@"description"];
            
            cell.createdLabel.frame = CGRectMake(40.0, 27.0+labelSize.height, 250.0, 0);
        }
        
        cell.urlnameLabel.text = [_jsonObject objectForKey:@"url_name"];
        cell.urlnameLabel.userInteractionEnabled = YES;
        [cell.urlnameLabel addGestureRecognizer:
         [[UITapGestureRecognizer alloc]
          initWithTarget:self action:@selector(leftAction:)]];
        
        NSString *imageURL = [_jsonObject objectForKey:@"profile_image_url"];
        NSData *data = [_imageDict objectForKey:indexPath];
        if (data) {
            cell.profileImage.image = [UIImage imageWithData:data];
        } else {
            Downloader *downloader = [[Downloader alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]] withIndexPath:indexPath];
            downloader.delegate = self;
            [downloader start];
        }
        
        cell.profileImage.layer.cornerRadius = 4.0;
        cell.profileImage.clipsToBounds = YES;
        //[cell.profileImage loadImage:imageURL];
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@投稿", _items];
        } else if (indexPath.row == 1) {
            cell.textLabel.text =[NSString stringWithFormat:@"%@フォロー", _following];
        } else if (indexPath.row == 2) {
            cell.textLabel.text =[NSString stringWithFormat:@"%@フォロワー", _followers];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *tmp = [_jsonObject objectForKey:@"description"];
        tmp = [NSString stringWithFormat:@"%@", tmp];
        if (tmp == nil || [tmp isEqualToString:@"<null>"]) {
            return 43.0f;
        } else {
            CGSize labelSize = [tmp sizeWithFont:[UIFont systemFontOfSize:15]
                               constrainedToSize:CGSizeMake(250, 1000)
                                   lineBreakMode:NSLineBreakByWordWrapping];
            if ((labelSize.height + 32.0f) > 43.0f) {
                return labelSize.height + 32.0f;
            } else {
                return 43.0f;
            }
        }
    } else {
        return 43.0f;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"プロフィール";
            break;
        default:
            return @"ユーザ情報";
            break;
    }
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
