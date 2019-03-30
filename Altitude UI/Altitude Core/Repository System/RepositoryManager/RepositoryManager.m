//
//  RepoManager.m
//  Altitude Core
//
//  Created by Dara on 07/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "RepositoryManager.h"

@interface RepositoryManager ()

- (void)updatePackages;

@end

@implementation RepositoryManager

- (instancetype)init {
    self = super.init;
    
    _repositories = NSMutableDictionary.new;
    _downloads = NSMutableArray.new;
    _packages = NSDictionary.new;
    
    return self;
}

- (void)addRepositoryWithURL:(NSURL *)url {
    NSDictionary *json = [NSDictionary dictionaryWithJSONAtURL:url];
    Repository *repo = [Repository repositoryWithDictionary:json URL:url manager:self];
    
    _repositories[url.copy] = repo;
    
    [self updatePackages];
}

- (void)removeRepositoryWithURL:(NSURL *)url {
    [_repositories removeObjectForKey:url];
    
    [self updatePackages];
}

- (void)updatePackages {
    // How it works :
    // 1| get all pkgs from 1 repo
    // 2| for each pkg, check if already exists
    // 3|   if exists: keep the one with the highest ver
    // 4|   else: set it normally
    // 5| goto 1 for next repo
    
    NSMutableDictionary<NSString *, Package *> *pkgs = NSMutableDictionary.new;
    
    Package *pre = nil;
    for (Repository *repo in _repositories.objectEnumerator) {
        for (Package *pkg in repo.packages.objectEnumerator) {
            if ((pre = pkgs[pkg.identifier])) {
                if ([pkg.version isGreaterThanOrEqualTo:pre.version]) {
                    pkgs[pkg.identifier] = pkg;
                }
                
                // TODO: Merge versions.
            } else {
                pkgs[pkg.identifier] = pkg;
            }
        }
    }
    
    _packages = pkgs;
}

- (nullable Download *)downloadPackageWithId:(NSString *)ident version:(PackageVersion *)ver repository:(Repository *)repo {
    Package *pkg;
    if ((pkg = repo.packages[ident])) {
        Download *dl = [pkg downloadWithVersion:ver];
        
        if (dl == nil) return nil;
        
        [_downloads addObject:dl];
        
        // __unsafe_unretained typeof(self) wself = self;
        dl.onFinished = ^(Download * _Nonnull dl, NSURL * _Nonnull output) {
            if (self->_onDownloadFinished) {
                self->_onDownloadFinished(dl, output);
            }
            [self->_downloads removeObject:dl];
        };
        dl.onError = ^(Download * _Nonnull dl, NSError * _Nonnull err) {
            if (self->_onDownloadError) {
                self->_onDownloadError(dl, err);
            }
            [self->_downloads removeObject:dl];
        };
        dl.onProgressChanged = ^(Download * _Nonnull dl, double previousProgress) {
            if (self->_onDownloadProgressChanged) {
                self->_onDownloadProgressChanged(dl, previousProgress);
            }
        };
        
        [dl resume];
        
        return dl;
    } else {
        NSLog(@"Package with id '%@' not found in repo at '%@'", ident, repo.url);
        return nil;
    }
}

- (nullable Download *)downloadPackageWithId:(NSString *)ident repository:(Repository *)repo {
    Package *pkg;
    if ((pkg = repo.packages[ident])) {
        Download *dl = pkg.download;
        [_downloads addObject:dl];
        
        // __unsafe_unretained typeof(self) wself = self;
        dl.onFinished = ^(Download * _Nonnull dl, NSURL * _Nonnull output) {
            if (self->_onDownloadFinished) {
                self->_onDownloadFinished(dl, output);
            }
            [self->_downloads removeObject:dl];
        };
        dl.onError = ^(Download * _Nonnull dl, NSError * _Nonnull err) {
            if (self->_onDownloadError) {
                self->_onDownloadError(dl, err);
            }
            [self->_downloads removeObject:dl];
        };
        dl.onProgressChanged = ^(Download * _Nonnull dl, double previousProgress) {
            if (self->_onDownloadProgressChanged) {
                self->_onDownloadProgressChanged(dl, previousProgress);
            }
        };
        
        [dl resume];
        
        return dl;
    } else {
        NSLog(@"Package with id '%@' not found in repo at '%@'", ident, repo.url);
        return nil;
    }
}

- (nullable Package *)packageWithId:(NSString *)ident {
    Package *pkg = nil;
    Package *tmp = nil;
    
    for (Repository *repo in _repositories.objectEnumerator) {
        tmp = repo.packages[ident];
        
        if (!pkg) {
            pkg = tmp;
        } else if (tmp && [tmp.version isGreaterThanOrEqualTo:pkg.version]) {
            pkg = tmp;
        }
    }
    
    return pkg;
}

- (nullable Download *)downloadPackageWithId:(NSString *)ident {
    Package *pkg = [self packageWithId:ident];
    if (!pkg) return nil;
    return [self downloadPackageWithId:ident repository:pkg.parentRepository];
}

- (nonnull NSArray<Package *> *)packagesWithId:(NSString *)ident {
    NSMutableArray<Package *> *all = NSMutableArray.new;
    Package *tmp = nil;
    
    for (Repository *repo in _repositories.objectEnumerator) {
        if ((tmp = repo.packages[ident])) {
            [all addObject:tmp];
        }
    }
    
    return all;
}

- (NSArray<Package *> *)searchPackagesWithPattern:(NSString *)pattern {
    
    // Trim whitespaces and newlines.
    pattern = [pattern stringByTrimmingCharactersInSet:
              NSCharacterSet.whitespaceAndNewlineCharacterSet];
    
    // Make the pattern case-insensitive.
    pattern = pattern.lowercaseString;
    
    // Order of appearance in search for match :
    // 1- identifier
    // 2- exact name
    // 3- occurence in name
    // 4- occurence in description
    
    NSMutableArray<Package *> *identMatches = NSMutableArray.new;
    NSMutableArray<Package *> *exactMatches = NSMutableArray.new;
    NSMutableArray<Package *> *nameMatches  = NSMutableArray.new;
    NSMutableArray<Package *> *descMatches  = NSMutableArray.new;
    
    
    for (Package *pkg in self.packages.objectEnumerator) {
        
        if ([pkg.identifier.lowercaseString isEqualToString:pattern]) {
            // "identifier" match
            [identMatches addObject:pkg];
            
        } else if ([pkg.name.lowercaseString isEqualToString:pattern]) {
            // "exact name" match
            [exactMatches addObject:pkg];
            
        } else if ([pkg.name.lowercaseString containsString:pattern]) {
            // "occurence in name" match
            [nameMatches addObject:pkg];
            
        } else if ([pkg.shortDescription.lowercaseString containsString:pattern]) {
            // "occurence in description" match
            [descMatches addObject:pkg];
        }
        
    }
    
    NSComparisonResult (^comparePkg)(Package *pkg1, Package *pkg2) =
    ^NSComparisonResult(Package *pkg1, Package *pkg2) {
        NSComparisonResult result;
        
        result = [pkg1.name localizedCaseInsensitiveCompare:pkg2.name];
        
        if (result == NSOrderedSame && [pkg1.version isNotEqualTo:pkg2.version]) {
            result = [pkg1 isGreaterThan:pkg2] ? NSOrderedDescending : NSOrderedAscending;
        }
        
        return result;
    };
    
    // Sort every result alphabetically.
    [identMatches sortUsingComparator:comparePkg];
    [exactMatches sortUsingComparator:comparePkg];
    [nameMatches  sortUsingComparator:comparePkg];
    [descMatches  sortUsingComparator:comparePkg];
    
    // Concatenate every array into one so it respects the correct order.
    NSMutableArray<Package *> *all = NSMutableArray.new;
    [all addObjectsFromArray:identMatches];
    [all addObjectsFromArray:exactMatches];
    [all addObjectsFromArray:nameMatches];
    [all addObjectsFromArray:descMatches];
    
    return all;
}

@end
