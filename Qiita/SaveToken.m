//
//  SaveToken.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/11/23.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "SaveToken.h"

@implementation SaveToken

@synthesize tokens = _tokens;
@synthesize url_names = _url_names;
@synthesize current_token = _current_token;

static SaveToken *_sharedInstance = nil;

+ (SaveToken*)sharedManager
{
    // インスタンスをつくる
    if (!_sharedInstance) {
        _sharedInstance = [[SaveToken alloc] init];
    }
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

// Tokenを追加する
- (void)add_token:(NSString *)token add_url_name:(NSString *)url_name
{
    // _tokensを初期化
    if (!_tokens) {
        _tokens = [[NSMutableArray alloc] init];
    }
    // _url_namesを初期化
    if (!_url_names)
    {
        _url_names = [[NSMutableArray alloc] init];
    }
    
    // _tokensを追加
    [_tokens addObject:token];
    
    // _url_nameを追加
    [_url_names addObject:url_name];
    
    [self save];
}

// Tokenを削除する
- (void)delete_token:(NSIndexPath *)indexPath
{
    // 引数を確認する
    if (indexPath.row > [_tokens count] - 1)
    {
        return;
    }
    
    // AlarmItemを削除する
    [_tokens removeObjectAtIndex:indexPath.row];
    [_url_names removeObjectAtIndex:indexPath.row];
    
    [self save];
}

// ログイン中のTokenを設定する
- (void)set_current_token:(NSIndexPath *)indexPath
{
    // _current_tokenを初期化
    if (!_current_token)
    {
        _current_token = [[NSString alloc] init];
    }
    
    // 引数を確認する
    if (indexPath.row < [_tokens count])
    {
        _current_token = _tokens[indexPath.row];
    }
    
    [self save];
}

#pragma mark

// Tokenの永続化
#pragma mark 
- (void)save
{
    // _tokens
    _tokens_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _tokens_directory = [_tokens_paths objectAtIndex:0];
    _tokens_filePath = [_tokens_directory stringByAppendingPathComponent:@"tokens_data.dat"];
    
    // _url_names
    _url_names_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _url_names_directory = [_url_names_paths objectAtIndex:0];
    _url_names_filePath = [_url_names_directory stringByAppendingPathComponent:@"url_names_data.dat"];
    
    // _current_token
    _current_token_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _current_token_directory = [_current_token_paths objectAtIndex:0];
    _current_token_filePath = [_current_token_directory stringByAppendingPathComponent:@"current_token_data.dat"];
    
    // save
    [NSKeyedArchiver archiveRootObject:_tokens toFile:_tokens_filePath];
    [NSKeyedArchiver archiveRootObject:_url_names toFile:_url_names_filePath];
    [NSKeyedArchiver archiveRootObject:_current_token toFile:_current_token_filePath];
}

- (void)load
{
    // _tokens
    _tokens_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _tokens_directory = [_tokens_paths objectAtIndex:0];
    _tokens_filePath = [_tokens_directory stringByAppendingPathComponent:@"tokens_data.dat"];
    
    // _url_names
    _url_names_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _url_names_directory = [_url_names_paths objectAtIndex:0];
    _url_names_filePath = [_url_names_directory stringByAppendingPathComponent:@"url_names_data.dat"];
    
    // _current_tokenOfVibration
    _current_token_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _current_token_directory = [_current_token_paths objectAtIndex:0];
    _current_token_filePath = [_current_token_directory stringByAppendingPathComponent:@"current_token_data.dat"];
   
    // load
    _tokens = [NSKeyedUnarchiver unarchiveObjectWithFile:_tokens_filePath];
    _url_names = [NSKeyedUnarchiver unarchiveObjectWithFile:_url_names_filePath];
    _current_token = [NSKeyedUnarchiver unarchiveObjectWithFile:_current_token_filePath];
}

@end
