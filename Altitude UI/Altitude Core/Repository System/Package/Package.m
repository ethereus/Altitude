//
//  Package.m
//  Altitude Core
//
//  Created by Dara on 07/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "Package.h"

@interface Package () // Private

- (nullable Download *)downloadWithLocation:(nonnull NSString *)location;
- (BOOL)extractWithoutCleanup;

@end


@implementation Package

+ (instancetype)packageWithDictionary:(NSDictionary *)dict identifier:(NSString *)ident repository:(Repository *)repo {
    Package *pkg = Package.new;
    NSObject *obj;
    
    pkg.identifier = ident;
    pkg.parentRepository = repo;
    
    pkg.name = ((NSString *)dict[@"NAME"]).stringByTrimmingPackageSingleLineProperty;
    pkg.developer = ((NSString *)
                     dict[@"DEVELOPER"]).stringByTrimmingPackageSingleLineProperty;
    pkg.category = ((NSString *)
                    dict[@"CATEGORY"]).stringByTrimmingPackageSingleLineProperty;
    
    pkg.type = PackageTypeWithString(dict[@"TYPE"]);
    
    obj = dict[@"LOCATION"];
    if ([obj isKindOfClass:NSString.class]) {
        pkg.location = (NSString *)obj;
    }
    
    obj = dict[@"DESCRIPTION"];
    if ([obj isKindOfClass:NSString.class]) {
        pkg.shortDescription = (NSString *)obj;
    }
    
    obj = dict[@"DEPENDENCIES"];
    if ([obj isKindOfClass:NSArray.class]) {
        pkg.dependencies = (NSArray *)obj;
    }
    
    obj = dict[@"SIP_DISABLED"];
    if ([obj isKindOfClass:NSNumber.class]) {
        pkg.requiresSIPDisabled = ((NSNumber *)obj).boolValue;
    }
    
    obj = dict[@"ICON"];
    if ([obj isKindOfClass:NSString.class]) {
        pkg.icon = [NSURL URLWithString:(NSString *)obj];
    }
    
    // Mandatory
    if (dict[@"VERSION"])
        pkg.version = [PackageVersion versionWithString:dict[@"VERSION"]];
    
    // Optional
    if (dict[@"OTHER_VERSIONS"]) {
        NSMutableDictionary<PackageVersion *, NSString *> *versioned = NSMutableDictionary.new;
        NSDictionary<NSString *, NSString *> *others = dict[@"OTHER_VERSIONS"];
        
        NSEnumerator<NSString *> *keys = others.keyEnumerator;
        for (NSString *ver in keys) {
            PackageVersion *pkgVer = [PackageVersion versionWithString:ver];
            versioned[pkgVer] = others[ver];
        }
        
        pkg.versionedLocations = versioned;
    } else pkg.versionedLocations = nil;
    
    if (!pkg.name || !pkg.shortDescription || [pkg.shortDescription.className isEqualToString:@"NSString"] || !pkg.developer || !pkg.location || pkg.type == PackageTypeUnknown || !pkg.version) {
        @throw [ASException exceptionWithType:kASExceptionMalformedPackage reason:[NSString stringWithFormat:@"Package named '%@' is malformed. Package = %@", pkg.name, pkg]];
    }
    
    return pkg;
}

- (Download *)download {
    return [self downloadWithLocation:_location];
}

- (Download *)downloadWithVersion:(PackageVersion *)ver {
    if ([_version isEqualTo:ver]) {
        return [self downloadWithLocation:_location];
    } else if ([_versionedLocations.keyEnumerator doesContain:ver]) {
        NSString *location = _versionedLocations[ver];
        return [self downloadWithLocation:location];
    }
    
    else @throw [ASException exceptionWithType:kASExceptionVersionNotFound reason:[NSString stringWithFormat:@"Version '%@' was not found on package : %@", ver, self]];
}

- (Download *)downloadWithLocation:(NSString *)location {
    switch (_type) {
        case PackageTypeRunCommand:
        case PackageTypeApplication:
        case PackageTypeTweak:
        case PackageTypeTheme: {
            NSURL *url = [NSURL URLWithString:location];
            
            NSURL *output = self.zipPath;
            
            Download *dl = [Download downloadWithURL:url output:output];
            
            return dl;
        }
            
        default: {
            @throw [ASException exceptionWithType:kASExceptionUnknownPackageType reason:[NSString stringWithFormat:@"Trying to download a package with unknown type. Package = %@", self]];
        }
    }
}

- (BOOL)extractWithoutCleanup {
    // Check that the package is already downloaded and that it is not a directory.
    BOOL isDir = NO;
    if (![NSFileManager.defaultManager fileExistsAtPath:self.zipPath.path isDirectory:&isDir]) {
        NSLog(@"Error : Trying to extract non-downloaded package with id '%@' and repository URL '%@'", _identifier, _parentRepository.url);
        
        return NO;
        
    } else if (isDir) {
        NSLog(@"Error : Found directory while expecting ZIP file at path : %@", self.zipPath);
        
        return NO;
    }
    
    NSURL *directory = self.extractedPath;
    NSError *err = nil;
    
    // Remove if directory already exists.
    if ([NSFileManager.defaultManager fileExistsAtPath:directory.path]) {
        [NSFileManager.defaultManager removeItemAtPath:directory.path error:&err];
        if (err) {
            NSLog(@"Error while removeing file at path : %@", directory.path);
            return NO;
        }
    }
    
    // Create directory.
    [NSFileManager.defaultManager createDirectoryAtURL:directory withIntermediateDirectories:YES attributes:nil error:&err];
    if (err) {
        NSLog(@"Error while creating directory at path : %@", directory.path);
        return NO;
    }
    
    // Extract zip file.
    BOOL ok = UnzipFileIntoDirectory(self.zipPath, directory);
    if (ok) {
        // We might want to skip hidden files? Idk.
        NSArray<NSURL *> *files = [NSFileManager.defaultManager contentsOfDirectoryAtURL:directory includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:&err];
        
        if (err) {
            NSLog(@"Error while listing files of directory at path : %@", directory.path);
            return NO;
        }
        
        if (files.count == 0) {
            NSLog(@"Error : Found empty package while extracting at path : %@", directory);
            return NO;
        } else if (files.count == 1) {
            [NSFileManager.defaultManager
             fileExistsAtPath:files[0].path isDirectory:&isDir];
            
            if (isDir) {
                NSArray<NSURL *> *subFiles = [NSFileManager.defaultManager contentsOfDirectoryAtURL:directory includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsHiddenFiles error:&err];
                
                if (err) {
                    NSLog(@"Error while listing files of directory at path : %@", files[0].path);
                    return NO;
                }
                
                for (NSURL *fileURL in subFiles) {
                    NSString *name = fileURL.lastPathComponent;
                    NSURL *targetURL = [directory URLByAppendingPathComponent:name];
                    
                    [NSFileManager.defaultManager moveItemAtURL:fileURL
                                                          toURL:targetURL error:&err];
                    
                    if (err) {
                        NSLog(@"Error while moving file at '%@' into parent directory '%@'", fileURL.path, targetURL.URLByDeletingLastPathComponent.path);
                    }
                }
            } else {
                NSLog(@"Warning : Package '%@' from repository at url '%@' only contains one file", _identifier, _parentRepository.url);
            }
        }
    }
    
    return ok;
}

- (BOOL)extract {
    BOOL ok = self.extractWithoutCleanup;
    NSError *err = nil;
    
    if (ok) {
        [NSFileManager.defaultManager removeItemAtURL:self.zipPath error:&err];
        
        if (err) {
            NSLog(@"Warning while trying to remove zip archive for cleanup at '%@' : %@", self.zipPath, err);
        }
    } else {
        if ([NSFileManager.defaultManager fileExistsAtPath:self.extractedPath.path]) {
            [NSFileManager.defaultManager removeItemAtURL:self.extractedPath error:&err];
            
            if (err) {
                NSLog(@"Warning while trying to remove failed extraction attempt at '%@' : %@", self.extractedPath.path, err);
            }
        }
    }
    
    return ok;
}

- (BOOL)extractAndPreserveArchive {
    if (!self.extractWithoutCleanup) {
        NSError *err = nil;
        if ([NSFileManager.defaultManager fileExistsAtPath:self.extractedPath.path]) {
            [NSFileManager.defaultManager removeItemAtURL:self.extractedPath error:&err];
            
            if (err) {
                NSLog(@"Warning while trying to remove failed extraction attempt at '%@' : %@", self.extractedPath.path, err);
            }
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark Overrides

- (NSString *)description {
    NSString *typeString = PackageTypeDescription(_type);
    
    // At least, it looks good in the console.
    NSString *s = [NSString stringWithFormat:@"{\r    NAME = '%@',\r    DESCRIPTION = '%@',\r    DEVELOPER = '%@',\r    ICON = '%@',\r    TYPE = '%@',\r    LOCATION = '%@'\r,    OTHER_VERSIONS = %@\r}", _name, _shortDescription, _developer, _icon, typeString, _location, _versionedLocations];
    
    return s;
}

#pragma mark Dynamic properties

- (NSURL *)extractedPath {
    return [NSApp.pathToPackagesDirectory URLByAppendingPathComponent:_identifier];
}

- (NSURL *)zipPath {
    return [NSApp.pathToPackagesDirectory URLByAppendingPathComponent:
            [_identifier stringByAppendingString:@".zip"]];
}

@end
