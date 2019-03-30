//
//  NSString+AltitudeStore.m
//  Altitude Core
//
//  Created by Dara on 23/11/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "NSString+AltitudeStore.h"

@implementation NSString (AltitudeStore)

- (NSString *)stringByTrimmingPackageSingleLineProperty {
    NSMutableString *result = NSMutableString.new;
    NSUInteger length = self.length;
    // NOTE: Here, whitespace does not designate spaces but
    // only : tabs, newlines, carriage returns, and vertiacal
    // tabs.
    // Spaces are perfectly acceptable and should not be removed.
    BOOL foundWhitespaceToTrim = NO;
    unichar currentChar;
    NSCharacterSet *illegalSet = NSCharacterSet.whitespaceAndNewlineCharacterSet;
    
    for (NSUInteger i = 0; i < length && !foundWhitespaceToTrim; ++i) {
        currentChar = [self characterAtIndex:i];
        
        // Spaces are fine.
        if (currentChar != ' ' && [illegalSet characterIsMember:currentChar]) {
            foundWhitespaceToTrim = YES;
        } else {
            [result appendFormat:@"%c", currentChar];
        }
    }
    
    // Trim the useless spaces at the start and the end of the package name/id and return.
    NSCharacterSet *spaceSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    return [result stringByTrimmingCharactersInSet:spaceSet];
}

@end
