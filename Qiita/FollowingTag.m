//
//  FollowingTag.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/12/02.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "FollowingTag.h"
#import "SaveToken.h"

@implementation FollowingTag
@synthesize tags = _tags;

static FollowingTag *_sharedInstance = nil;

+ (FollowingTag*)sharedManager
{
    // インスタンスをつくる
    if (!_sharedInstance) {
        _sharedInstance = [[FollowingTag alloc] init];
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

// Tagを取得する
- (void)update_tags:(NSString *)url_name
{
    if (!url_name) {
        NSString *url = [NSString stringWithFormat:@"https://qiita.com/api/v1/user?token=%@", [SaveToken sharedManager].current_token];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        _step = 0;
    } else {
        NSString *url = [NSString stringWithFormat:@"https://qiita.com/api/v1/users/%@/following_tags", url_name];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        _step = 1;
    }
}

// 非同期通信 ヘッダーが返ってきた
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // データを初期化
    _jsonData = [[NSMutableData alloc] initWithData:0];
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
}

// 非同期通信 ダウンロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error=nil;
    
    if (!_step) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:_jsonData options:NSJSONReadingAllowFragments error:&error];;
        NSString *url_name = [[NSString alloc] initWithFormat:@"%@", [jsonDict objectForKey:@"url_name"]];
        [self update_tags:url_name];
    } else {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_jsonData options:NSJSONReadingAllowFragments error:&error];;
        [self set_tags:jsonArray];
    }
}

// Tagを更新する
- (void)set_tags:(NSArray *)set_tags
{
    // _tagsを初期化
    if (!_tags) {
        _tags = [[NSArray alloc] init];
    }
   
    // _tagsに代入
    _tags = set_tags;
    
    [self save];
}

// Tagの永続化
#pragma mark
- (void)save
{
    // _tags
    _tags_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _tags_directory = [_tags_paths objectAtIndex:0];
    _tags_filePath = [_tags_directory stringByAppendingPathComponent:@"tags_data.dat"];
    
    // save
    [NSKeyedArchiver archiveRootObject:_tags toFile:_tags_filePath];
}

- (void)load
{
    // _tags
    _tags_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _tags_directory = [_tags_paths objectAtIndex:0];
    _tags_filePath = [_tags_directory stringByAppendingPathComponent:@"tags_data.dat"];
    
    // load
    _tags = [NSKeyedUnarchiver unarchiveObjectWithFile:_tags_filePath];
}

@end
