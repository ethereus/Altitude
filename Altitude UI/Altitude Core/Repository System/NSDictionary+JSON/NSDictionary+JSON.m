//
//  NSDictionary+JSON.m
//  Altitude Core
//
//  Created by Dara on 02/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

+ (instancetype)dictionaryWithJSONAtURL:(NSURL *)url {
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data) {
        @throw [ASException exceptionWithType:kASExceptionContentsOfURL reason:[NSString stringWithFormat:@"Unable to get contents' data of URL '%@'", url]];
    }
    
    NSError *err = nil;
    
    NSObject *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    
    if (err) {
        @throw [ASException exceptionWithType:kASExceptionJSONReadingError reason:[NSString stringWithFormat:@"Error while reading JSON data at URL '%@': %@", url, err]];
    }
    
    if (![json isKindOfClass:NSDictionary.class]) {
        @throw [ASException exceptionWithType:kASExceptionJSONIsNotADictionary reason:[NSString stringWithFormat:@"JSON file at URL '%@' does not represent a dictionary, found type '%@' instead", url, json.className]];
    }
    
    return (NSDictionary *)json;
}

@end
