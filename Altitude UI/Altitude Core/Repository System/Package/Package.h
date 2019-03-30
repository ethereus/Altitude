//
//  Package.h
//  Altitude Core
//
//  Created by Dara on 07/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PackageType.h"
#import "Download.h"
#import "NSApplication+DataDir.h"
#import "Repository.h"
#import "PackageVersion.h"
#import "Unzip.h"
#import "../../NSString+AltitudeStore.h"
#import "../../SharedMacros.h"

@class Repository;

NS_ASSUME_NONNULL_BEGIN

/// A type representing a repository's package and containing the package's metadata.
@interface Package : NSObject

@property (copy) NSString *identifier;
@property (weak) Repository *parentRepository;
@property (copy) NSString *name;
@property (copy) NSString *shortDescription;
@property (copy) NSString *developer;
@property (copy, nullable) NSURL *icon;
@property PackageType type;
@property (copy, nullable) NSString *category;
@property (copy) NSString *location;
@property (copy) PackageVersion *version;
@property (nullable) NSDictionary<PackageVersion *, NSString *> *versionedLocations;
@property BOOL requiresSIPDisabled;
@property (nullable) NSArray<NSString *> *dependencies;

/// Path pointing to where the downloaded package archive should be.
@property (copy, nonatomic, readonly) NSURL *zipPath;
/// Path pointing to where the extracted package archive should be.
@property (copy, nonatomic, readonly) NSURL *extractedPath;

+ (__throws instancetype)packageWithDictionary:(NSDictionary *)dict identifier:(NSString *)ident repository:(Repository *)repo;

/// Creates a Download object to download the package.
///
/// Use `Download#resume` to start downloading.
- (__throws Download *)download;
/// Creates a Download object to download the package with a specific version.
///
/// Use `Download#resume` to start downloading.
- (__throws Download *)downloadWithVersion:(PackageVersion *)ver;

- (BOOL)extract;
- (BOOL)extractAndPreserveArchive;

@end

NS_ASSUME_NONNULL_END
