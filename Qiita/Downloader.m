//
//  Downloader.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/11/27.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "Downloader.h"

@implementation Downloader

- (id)initWithURLRequest:(NSURLRequest *)request withIndexPath:(NSIndexPath *)indexPath
{
    self = [super init];
    if (self)
    {
        _indexPath = indexPath;
        _request = request;
    }
    return self;
}

- (void)start
{
    _data = [[NSMutableData alloc] init];
    [[[NSURLConnection alloc] initWithRequest:_request delegate:self] start];
}

- (NSIndexPath *)indexPath
{
    return _indexPath;
}

- (NSData *)data
{
    return _data;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(downloaderDidFinish:)])
    {
        [self.delegate downloaderDidFinish:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(downloaderDidFailed:withError:)])
    {
        [self.delegate downloaderDidFailed:self withError:error];
    }
}

@end



