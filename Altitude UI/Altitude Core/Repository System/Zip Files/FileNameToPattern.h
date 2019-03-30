//
//  FileNameToPattern.h
//  Altitude Core
//
//  Created by Dara on 24/10/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Transform a file name into a properly escaped pattern
/// that can be used by the unzip command to specify this
/// file.
///
/// @param fileName The file's name to translate.
///
/// @returns The translated pattern.
NSString *FileNameToUnzipPattern(NSString *fileName);

NS_ASSUME_NONNULL_END
