//
//  Repository.m
//  Altitude Core
//
//  Created by Dara on 07/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "Repository.h"

@implementation Repository

+ (instancetype)repositoryWithDictionary:(NSDictionary *)dict URL:(NSURL *)url manager:(RepositoryManager *)manager {
    Repository *repo = Repository.new;
    NSObject *obj;
    
    repo.url = url;
    repo.parentManager = manager;
    
    obj = dict[@"REPO_NAME"];
    if ([obj isKindOfClass:NSString.class]) {
        repo.name = (NSString *)obj;
    }
    
    obj = dict[@"REPO_DESCRIPTION"];
    if ([obj isKindOfClass:NSString.class]) {
        repo.shortDescription = (NSString *)obj;
    }
    
    obj = dict[@"REPO_ICON"];
    if ([obj isKindOfClass:NSString.class]) {
        repo.icon = [NSURL URLWithString:(NSString *)obj];
    }
    
    NSDictionary<NSString *, NSDictionary *> *pkgs = nil;
    obj = dict[@"REPO_PACKAGES"];
    if ([obj isKindOfClass:NSDictionary.class]) {
        pkgs = (NSDictionary *)obj;
    }
    
    NSEnumerator<NSString *> *keys = pkgs.keyEnumerator;
    NSMutableDictionary<NSString *, Package *> *d = NSMutableDictionary.new;
    if (pkgs) for (NSString *ident in keys) {
        obj = pkgs[ident];
        
        if ([obj isKindOfClass:NSDictionary.class]) {
            Package *pkg = [Package packageWithDictionary:(NSDictionary *)obj identifier:ident repository:repo];
            d[ident] = pkg;
        } else {
            NSLog(@"WARNING: Malformed package of wrong type in repository at '%@'", repo.url);
        }
    }
    
    repo.packages = d;
    
    if (!repo.name || !repo.shortDescription || !pkgs) {
        NSLog(@"ERROR: Malformed repository at '%@'", repo.url);
        return nil;
    }
    
    return repo;
}

@end
