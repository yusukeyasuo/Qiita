//
//  LoginViewController.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/11/24.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

@interface LoginViewController : UIViewController
{
    IBOutlet UIImageView *_qiita_icon;
    IBOutlet UITextField *_username;
    IBOutlet UITextField *_password;
    IBOutlet UIButton *_login;
    
    NSMutableData *_json_data;
    NSDictionary *_json_object;
    NSURLConnection *_connection;
}

- (IBAction)pushLogin:(id)sender;
@end
