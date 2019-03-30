//
//  ASExceptionType.h
//  Altitude Core
//
//  Created by Dara on 27/11/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#define $(enumValName) kASException ## enumValName

typedef NS_ENUM(NSUInteger, ASExceptionType) {
    // NSDictionary+JSON
    $(JSONIsNotADictionary),
    $(JSONReadingError),
    $(ContentsOfURL),
    
    // Package
    $(MalformedPackage),
    $(UnknownPackageType),
    $(VersionNotFound),
};

#undef $
