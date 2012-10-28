//
//  UIAsyncImageView.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/28.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAsyncImageView : UIImageView
{
    NSURLConnection *conn;
    NSMutableData *data;
}

-(void)loadImage:(NSString *)url;
-(void)abort;

@end
