//
//  PackageVersion.h
//  Altitude Core
//
//  Created by Dara on 15/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "../../SharedMacros.h"

NS_ASSUME_NONNULL_BEGIN

/// A representation of a package's version (format: MAJOR.minor.patch-mark)
///
/// @warning `mark` should NOT be a numeric value.
@interface PackageVersion : NSObject <NSCopying>

@property NSUInteger major;
@property NSUInteger minor;
@property NSUInteger patch;

@property (copy) NSString *mark;

/// Create a `PackageVersion` object from a version's ASCII string representation.
///
/// @returns An initialised `PackageVersion` object.
///
/// @warning This method throws an exception if the string version is malformed.
+ (instancetype __throws)versionWithString:(NSString *)repr;

- (BOOL)isEqualTo:(nullable PackageVersion *)object;
- (BOOL)isNotEqualTo:(nullable PackageVersion *)object;

- (BOOL)isGreaterThan:(nullable PackageVersion *)object;
- (BOOL)isGreaterThanOrEqualTo:(nullable PackageVersion *)object;
- (BOOL)isLessThan:(nullable PackageVersion *)object;
- (BOOL)isLessThanOrEqualTo:(nullable PackageVersion *)object;

@end

NS_ASSUME_NONNULL_END
