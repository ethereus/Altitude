//
//  PackageType.h
//  Altitude Core
//
//  Created by Dara on 07/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The type of package. It will decide how the package's value is interpreted and
/// how it is installed.
typedef NS_ENUM(NSUInteger, PackageType) {
    PackageTypeUnknown,
    PackageTypeApplication,
    PackageTypeTweak,
    PackageTypeTheme,
    PackageTypeRunCommand
};

/// Return the string value of the type.
NSString *PackageTypeDescription(PackageType type);

/// Return the type described by the given string.
PackageType PackageTypeWithString(NSString *string);

NS_ASSUME_NONNULL_END
