//
//  NSDictionary+JSON.h
//  Altitude Core
//
//  Created by Dara on 02/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "../../SharedMacros.h"
#import "../../Exception/ASException.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JSON)

/// Create a dictionary representing the JSON file found at the given URL.
///
/// @param url The URL pointing to the JSON file.
///
/// @returns An initialised dictionary containing the JSON file's data.
///
/// @warning In case of error while opening/reading the JSON file, this method
/// will throw an error.
+ (__throws instancetype)dictionaryWithJSONAtURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
