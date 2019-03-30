//
//  RepoManager.h
//  Altitude Core
//
//  Created by Dara on 07/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Repository.h"
#import "NSDictionary+JSON.h"

@class Repository;
@class Package;
@class PackageVersion;

NS_ASSUME_NONNULL_BEGIN

@interface RepositoryManager : NSObject

@property NSMutableDictionary<NSURL *, Repository *> *repositories;
@property NSMutableArray<Download *> *downloads;

@property void (^onDownloadFinished)(Download *, NSURL *output);
@property void (^onDownloadProgressChanged)(Download *, double previousProgress);
@property void (^onDownloadError)(Download *, NSError *);

- (void)addRepositoryWithURL:(NSURL *)url;
- (void)removeRepositoryWithURL:(NSURL *)url;

@property NSDictionary<NSString *, Package *> *packages;

- (nullable Download *)downloadPackageWithId:(NSString *)ident version:(PackageVersion *)ver repository:(Repository *)repo;
- (nullable Download *)downloadPackageWithId:(NSString *)ident repository:(Repository *)repo;
- (nullable Package *)packageWithId:(NSString *)ident;
- (nullable Download *)downloadPackageWithId:(NSString *)ident;
/// Array of all packages with the same id in each repository
- (NSArray<Package *> *)packagesWithId:(NSString *)ident;
// Array of all packages responding to a pattern.
- (NSArray<Package *> *)searchPackagesWithPattern:(NSString *)pattern;

@end

NS_ASSUME_NONNULL_END
