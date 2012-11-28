//
//  TokensViewController.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/11/25.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "TokensViewController.h"
#import "LoginViewController.h"
#import "SaveToken.h"

@interface TokensViewController ()

@end

@implementation TokensViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"アカウント管理";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 編集ボタンの表示
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.392 green:0.788 blue:0.078 alpha:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    if (self.tableView.editing) {
        [self setEditing:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [[SaveToken sharedManager].tokens count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row < [[SaveToken sharedManager].tokens count])
    {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.text = [[SaveToken sharedManager].url_names objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:0.2 blue:0.4 alpha:1];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"アカウントを追加";
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"アカウント";
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[SaveToken sharedManager] delete_token:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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
    
    if (indexPath.row < [[SaveToken sharedManager].tokens count]) {
        [[SaveToken sharedManager] set_current_token:indexPath];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self presentViewController:navController animated:YES completion:nil];
        
    }
}

@end
