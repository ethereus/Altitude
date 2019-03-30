//
//  Download.h
//  Altitude Core
//
//  Created by Dara on 13/08/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface Download : NSObject <NSURLSessionDownloadDelegate>

@property void (^onFinished)(Download *, NSURL * output);
@property void (^onProgressChanged)(Download *, double previousProgress);
@property void (^onError)(Download *, NSError *);

/// The URL targeting the content to download.
@property (readonly) NSURL *url;
/// The URL targeting the place the downloaded file should be moved to after
/// the download is finished.
/// If none is provided, the file should be handled using `Download#onDownloadFinished`
@property (readonly, nullable) NSURL *outputURL;

- (NSURLSession *)session;
- (NSURLSessionDownloadTask *)task;

/// This will be true if the download is not suspended nor cancelled.
@property (readonly) BOOL isDownloading;
/// This will be true if the download is suspended but not cancelled.
@property (readonly) BOOL isSuspended;

/// 0.1 = 10%, 0.5 = 50%, ...
@property (readonly) double progress;

/// Download the content an URL is pointing to.
///
/// The download is suspended by default, use `Download#resume` to start it.
/// If no output URL is provided, the downloaded file won't be moved from its
/// temporary position, in this case you need to deal with it using
/// `Download#onDownloadFinished`.
+ (instancetype)downloadWithURL:(NSURL *)url output:(nullable NSURL *)outputURL;

- (void)suspend;
- (void)resume;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
