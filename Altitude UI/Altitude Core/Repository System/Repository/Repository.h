//
//  Repository.h
//  Altitude Core
//
//  Created by Dara on 07/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Package.h"
#import "RepositoryManager.h"

@class Package;
@class RepositoryManager;

NS_ASSUME_NONNULL_BEGIN

@interface Repository : NSObject

@property (weak) RepositoryManager *parentManager;

@property (copy) NSString *name;
@property (copy) NSString *shortDescription;
@property (copy, nullable) NSURL *icon;
@property NSDictionary<NSString *, Package *> *packages;
@property (copy) NSURL *url;

+ (nullable instancetype)repositoryWithDictionary:(NSDictionary *)dict URL:(NSURL *)url manager:(RepositoryManager *)manager;

@end

NS_ASSUME_NONNULL_END
