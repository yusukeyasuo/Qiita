//
//  Downloader.h
//  Qiita
//
//  Created by yusuke_yasuo on 2012/11/27.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Downloader;

@protocol DownLoaderDelegate <NSObject>

- (void)downloaderDidFinish:(Downloader *)downloader;
- (void)downloaderDidFailed:(Downloader *)downloader withError:(NSError *)error;

@end

@interface Downloader : NSObject <NSURLConnectionDataDelegate>
{
    NSIndexPath *_indexPath;
    NSURLRequest *_request;
    NSMutableData *_data;
}

@property (nonatomic, weak) id<DownLoaderDelegate> delegate;
@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) NSIndexPath *indexPath;

- (id)initWithURLRequest:(NSURLRequest *)request withIndexPath:(NSIndexPath *)indexPath;
- (void)start;

@end
