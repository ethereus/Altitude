//
//  Unzip.h
//  Altitude Core
//
//  Created by Dara on 23/10/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Extract a ZIP file inside the given directory.
///
/// @param zipFile The path pointing to the ZIP file.
/// @param directory The path pointing to the directory.
///
/// @returns `YES` if the operation succeded, `NO` if the
/// operation failed.
BOOL UnzipFileIntoDirectory(NSURL *zipFile, NSURL *directory);

/// Extract items matching any of the provided patterns from
/// a ZIP file inside the given directory.
///
/// See : https://linux.die.net/man/1/unzip
///
/// @param zipFile The path pointing to the ZIP file.
/// @param patterns If an item matches any of those patterns
/// then it will be extracted.
/// @param directory The path pointing to the directory.
///
/// @returns `YES` if the operation succeded, `NO` if the
/// operation failed.
///
/// @warning To convert a file's name into a pattern use
/// `FileNameToUnzipPattern(fileName)` inside `FileNameToPattern.h`.
/// Not using this function will lead to security issues due to non
/// escaped characters.
BOOL UnzipItemsWithAnyOfPatternsIntoDirectory(NSURL *zipFile, NSArray<NSString *> *patterns, NSURL *directory);

/// Extract items matching any of the provided patterns from
/// a ZIP file inside the given directory.
///
/// See : https://linux.die.net/man/1/unzip
///
/// @param zipFile The path pointing to the ZIP file.
/// @param patterns If an item matches any of those patterns
/// then it will not be extracted.
/// @param directory The path pointing to the directory.
///
/// @returns `YES` if the operation succeded, `NO` if the
/// operation failed.
///
/// @warning To convert a file's name into a pattern use
/// `FileNameToUnzipPattern(fileName)` inside `FileNameToPattern.h`.
/// Not using this function will lead to security issues due to non
/// escaped characters.
BOOL UnzipFileExceptItemsWithAnyOfPatternsIntoDirectory(NSURL *zipFile, NSArray<NSString *> *patterns, NSURL *directory);

/// Extract a ZIP file inside the given directory by
/// passing the provided arguments to the `unzip` command.
///
/// See : https://linux.die.net/man/1/unzip
///
/// @param zipFile The path pointing to the ZIP file.
/// @param directory The path pointing to the directory.
/// @param arguments The arguments to be passed to the
/// `unzip` command.
///
/// @returns `YES` if the operation succeded, `NO` if the
/// operation failed.
///
/// @warning To convert a file's name into a pattern use
/// `FileNameToUnzipPattern(fileName)` inside `FileNameToPattern.h`.
/// Not using this function will lead to security issues due to non
/// escaped characters.
BOOL UnzipFileIntoDirectoryWithArguments(NSURL *zipFile, NSURL *directory, NSArray<NSString *> *arguments);

NS_ASSUME_NONNULL_END
