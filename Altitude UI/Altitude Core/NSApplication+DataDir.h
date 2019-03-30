//
//  NSApplication+DataDir.h
//  Altitude Core
//
//  Created by Dara on 08/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SharedMacros.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSApplication (DataDir)

/// Get path to "~/Library/Application Support/APP_NAME" and create it if it doesn't
/// already exist.
- (nullable NSURL *)pathToDataDirectory;

/// Get path to "~/Library/Application Support/APP_NAME/Packages" and create it if
/// it doesn't already exist.
///
/// This function will probably be removed later since it has quite a lot of duplicate
/// code.
- (nullable NSURL *)pathToPackagesDirectory;

@end

NS_ASSUME_NONNULL_END
