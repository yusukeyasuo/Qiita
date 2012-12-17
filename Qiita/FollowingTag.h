//
//  FollowingTag.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/12/02.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowingTag : NSObject
{
    NSArray *_tags;
    
    NSArray *_tags_paths;
    NSString *_tags_directory;
    NSString *_tags_filePath;
    
    NSURLConnection *_connection;
    NSMutableData *_jsonData;
    
    int _step;
}

@property (nonatomic, readonly) NSArray *tags;

+ (FollowingTag *)sharedManager;
- (void)update_tags:(NSString *)url_name;
- (void)save;
- (void)load;

@end
