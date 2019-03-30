//
//  NSApplication+DataDir.m
//  Altitude Core
//
//  Created by Dara on 08/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "NSApplication+DataDir.h"

@implementation NSApplication (DataDir)

- (nullable NSURL *)pathToDataDirectory {
    // Get path to "~/Library/Application Support"
    NSString *appSupp = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject;
    if (appSupp == nil) {
        NSLog(@"'~/Library/Application Support' not found");
        @throw [NSException exceptionWithName:@"NoAppSuppDir" reason:@"'~/Library/Application Support' not found" userInfo:nil];
    }
    // Get path to "~/Library/Application Support/APP_NAME"
    NSString *strPath = [appSupp stringByAppendingString:@"/" APP_NAME];
    NSURL *path = [NSURL fileURLWithPath:strPath];
    
    // Check that it exists and is a directory
    
    BOOL isDir = NO;
    BOOL exists = [NSFileManager.defaultManager fileExistsAtPath:strPath isDirectory:&isDir];
    NSError *err = nil;
    if (!exists) // If it doesn't exist, just create it
        [NSFileManager.defaultManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:&err];
    else if (!isDir) {
        NSLog(@"Path is not a directory : '%@', replacing...", strPath);
        
        // Strange... Just remove it and create a new directory
        
        [NSFileManager.defaultManager removeItemAtURL:path error:&err];
        
        if (err) {
            NSLog(@"Error while removing file at path '%@': %@", path.path, err);
            return nil;
        }
        
        [NSFileManager.defaultManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:&err];
        
        if (err) {
            NSLog(@"Error while creating directory at path '%@': %@", path.path, err);
            return nil;
        }
        
        NSLog(@"Done replacing");
    }
    
    if (err) {
        NSLog(@"Error while accessing data directory at path '%@': %@", strPath, err);
        return nil;
    }
    
    return path;
}

- (NSURL *)pathToPackagesDirectory {
    // Get path to "~/Library/Application Support"
    NSString *appSupp = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject;
    if (appSupp == nil) {
        NSLog(@"'~/Library/Application Support' not found");
        @throw [NSException exceptionWithName:@"NoAppSuppDir" reason:@"'~/Library/Application Support' not found" userInfo:nil];
    }
    // Get path to "~/Library/Application Support/APP_NAME/Packages"
    NSString *strPath = [appSupp stringByAppendingString:@"/" APP_NAME @"Packages"];
    NSURL *path = [NSURL fileURLWithPath:strPath];
    
    // Check that it exists and is a directory
    
    BOOL isDir = NO;
    BOOL exists = [NSFileManager.defaultManager fileExistsAtPath:strPath isDirectory:&isDir];
    NSError *err = nil;
    if (!exists) // If it doesn't exist, just create it
        [NSFileManager.defaultManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:&err];
    else if (!isDir) {
        NSLog(@"Path is not a directory : '%@', replacing...", strPath);
        
        // Strange... Just remove it and create a new directory
        
        [NSFileManager.defaultManager removeItemAtURL:path error:&err];
        
        if (err) {
            NSLog(@"Error while removing file at path '%@': %@", path.path, err);
            return nil;
        }
        
        [NSFileManager.defaultManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:&err];
        
        if (err) {
            NSLog(@"Error while creating directory at path '%@': %@", path.path, err);
            return nil;
        }
        
        NSLog(@"Done replacing");
    }
    
    if (err) {
        NSLog(@"Error while accessing data directory at path '%@': %@", strPath, err);
        return nil;
    }
    
    return path;
}

@end
