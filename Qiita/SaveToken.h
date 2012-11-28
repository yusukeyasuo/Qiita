//
//  SaveToken.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/11/23.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveToken : NSObject
{
    NSMutableArray *_tokens;
    NSMutableArray *_url_names;
    NSString *_current_token;
    
    NSArray *_tokens_paths;
    NSString *_tokens_directory;
    NSString *_tokens_filePath;
    
    NSArray *_url_names_paths;
    NSString *_url_names_directory;
    NSString *_url_names_filePath;
    
    NSArray *_current_token_paths;
    NSString *_current_token_directory;
    NSString *_current_token_filePath;
}

@property (nonatomic, readonly) NSArray *tokens;
@property (nonatomic, readonly) NSArray *url_names;
@property (nonatomic, readonly) NSString *current_token;

+ (SaveToken *)sharedManager;
- (void)add_token:(NSString *)token add_url_name:(NSString *)url_name;
- (void)delete_token:(NSIndexPath *)indexPath;
- (void)set_current_token:(NSIndexPath *)indexPath;
- (void)load;


@end
