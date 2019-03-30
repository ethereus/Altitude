//
//  Unzip.m
//  Altitude Core
//
//  Created by Dara on 23/10/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "Unzip.h"

#define UNZIP_LAUNCH_PATH (@"/usr/bin/unzip")

BOOL UnzipFileIntoDirectory(NSURL *zipFile, NSURL *directory) {
    NSTask *unzip = NSTask.new;
    
    // $ unzip file.zip -d outputDirectory
    // See : https://linux.die.net/man/1/unzip
    
    unzip.launchPath = UNZIP_LAUNCH_PATH;
    unzip.arguments = @[zipFile.path, @"-d", directory.path];
    
    [unzip launch];
    [unzip waitUntilExit];
    
    return (unzip.terminationStatus == 0 ? YES : NO);
}

BOOL UnzipItemsWithAnyOfPatternsIntoDirectory(NSURL *zipFile, NSArray<NSString *> *patterns, NSURL *directory) {
    
    // $ unzip file.zip -d outputDirectory filesToBeProcessed...
    // See : https://linux.die.net/man/1/unzip
    
    return UnzipFileIntoDirectoryWithArguments(zipFile, directory, patterns);
}

BOOL UnzipFileExceptItemsWithAnyOfPatternsIntoDirectory(NSURL *zipFile, NSArray<NSString *> *patterns, NSURL *directory) {
    
    // $ unzip file.zip -d outputDirectory -x filesToBeIgnored...
    // See : https://linux.die.net/man/1/unzip
    
    NSArray *args = [@[@"-x"] arrayByAddingObjectsFromArray:patterns];
    
    return UnzipFileIntoDirectoryWithArguments(zipFile, directory, args);
}

BOOL UnzipFileIntoDirectoryWithArguments(NSURL *zipFile, NSURL *directory, NSArray<NSString *> *arguments) {
    NSTask *unzip = NSTask.new;
    
    // $ unzip file.zip -d outputDirectory arguments...
    // See : https://linux.die.net/man/1/unzip
    
    unzip.launchPath = UNZIP_LAUNCH_PATH;
    unzip.arguments = [@[zipFile.path, @"-d", directory.path] arrayByAddingObjectsFromArray:arguments];
    
    [unzip launch];
    [unzip waitUntilExit];
    
    return (unzip.terminationStatus == 0 ? YES : NO);
}

// Clean up
#undef UNZIP_LAUNCH_PATH
