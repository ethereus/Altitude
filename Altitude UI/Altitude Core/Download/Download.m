//
//  Download.m
//  Altitude Core
//
//  Created by Dara on 13/08/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "Download.h"

@interface Download ()

@property (copy, nonnull) NSURL *url;
@property (copy, nullable) NSURL *outputURL;

@property NSURLSession *session;
@property NSURLSessionDownloadTask *task;

@property BOOL isDownloading;
@property BOOL isSuspended;

@property double progress;

@end


@implementation Download

+ (instancetype)downloadWithURL:(nonnull NSURL *)url output:(nullable NSURL *)outputURL {
    Download *dl = Download.new;
    
    dl.url = url;
    dl.outputURL = outputURL;
    dl.session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration delegate:dl delegateQueue:nil];
    dl.task = [dl.session downloadTaskWithURL:dl.url];
    dl.isDownloading = NO;
    dl.isSuspended = YES;
    dl.progress = 0;
    
    return dl;
}

- (void)suspend {
    _isDownloading = NO;
    _isSuspended = YES;
    
    [_task suspend];
}

- (void)cancel {
    _isDownloading = NO;
    _isSuspended = NO;
    
    [_task cancel];
}

- (void)resume {
    [_task resume];
    
    _isDownloading = YES;
    _isSuspended = NO;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    _isDownloading = NO;
    _isSuspended = NO;
    
    if (_outputURL) {
        NSError *err = nil;
        
        if ([NSFileManager.defaultManager fileExistsAtPath:_outputURL.path]) {
            NSError *err = nil;
            
            [NSFileManager.defaultManager removeItemAtURL:_outputURL error:&err];
            
            if (err) {
                NSLog(@"Error while removing file for replacement '%@': %@", _outputURL.path, err);
                if (_onError) _onError(self, err);
                return;
            }
        }
        
        [NSFileManager.defaultManager moveItemAtURL:location toURL:_outputURL error:&err];
        
        if (err) {
            NSLog(@"Error while moving file from '%@' to '%@': %@",
                  location.path, _outputURL.path, err);
            if (_onError) _onError(self, err);
            return;
        }
    }
    
    // Now that the everything is finished, its time to call
    // Download#onFinished
    if (_onFinished) {
        // Make sure to pass the current address for the file
        if (_outputURL) _onFinished(self, _outputURL);
        else            _onFinished(self, location);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    _isDownloading = NO;
    _isSuspended = NO;
    
    if (error) {
        NSLog(@"Error while downloading '%@': %@", _url, error);
        if (_onError) _onError(self, error);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    double previousProgress = _progress;
    _progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    
    if (_onProgressChanged && previousProgress != _progress) {
        _onProgressChanged(self, previousProgress);
    }
}

@end
