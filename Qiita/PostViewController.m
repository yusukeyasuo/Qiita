//
//  PostViewController.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/11/24.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"投稿";
        self.tabBarItem.image = [UIImage imageNamed:@"post"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.392 green:0.788 blue:0.078 alpha:1];
    
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

@end
