//
//  PackageVersion.m
//  Altitude Core
//
//  Created by Dara on 15/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "PackageVersion.h"

#define CHAR_IS_DIGIT(c) ('0' <= c && c <= '9')
#define CHAR_DIGIT_TO_NUM(c) (NSUInteger)(c - '0')

@implementation PackageVersion

+ (instancetype)versionWithString:(NSString *)repr {
    NSUInteger len = repr.length;
    
    PackageVersion *ver = PackageVersion.new;
    NSMutableString *mark = NSMutableString.new;
    
    NSUInteger state = 0;
    
    for (NSUInteger i = 0; i < len; i++) {
        unichar current = [repr characterAtIndex:i];
        
        if (current == ' ') continue;
        
        switch (state) {
            case 0: case 1: case 2: {
                if (current == '.' || current == '-') {
                    ++state;
                } else if (CHAR_IS_DIGIT(current)) {
                    switch (state) {
                        case 0: {
                            ver.major *= 10;
                            ver.major += CHAR_DIGIT_TO_NUM(current);
                            
                            break;
                        }
                            
                        case 1: {
                            ver.minor *= 10;
                            ver.minor += CHAR_DIGIT_TO_NUM(current);
                            
                            break;
                        }
                            
                        case 2: {
                            ver.patch *= 10;
                            ver.patch += CHAR_DIGIT_TO_NUM(current);
                            
                            break;
                        }
                            
                        default: ;
                    }
                } else {
                    // This allows version numbers like 1.2.0alpha
                    state = 3;
                    --i;
                }
                
                break;
            }
                
            default: {
                [mark appendFormat:@"%c", current];
                break;
            }
        }
    }
    
    ver.mark = mark;
    
    return ver;
}

#pragma mark Overrides

- (NSString *)description {
    if (_mark && _mark.length) return [NSString stringWithFormat:@"%lu.%lu.%lu%@", _major, _minor, _patch, _mark];
    else return [NSString stringWithFormat:@"%lu.%lu.%lu", _major, _minor, _patch];
}

- (instancetype)init {
    self = super.init;
    
    self.major = 0;
    self.minor = 0;
    self.patch = 0;
    
    self.mark = NSString.new;
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    PackageVersion *pkg = PackageVersion.new;
    
    pkg.major = _major;
    pkg.minor = _minor;
    pkg.patch = _patch;
    
    pkg.mark = _mark;
    
    return pkg;
}

#pragma mark Comparison

- (BOOL)isEqualTo:(PackageVersion *)object {
    return _major == object.major && _minor == object.minor && _patch == object.patch && (_mark == object.mark || [_mark isEqualToString:object.mark]);
}

- (BOOL)isNotEqualTo:(PackageVersion *)object {
    return _major != object.major || _minor != object.minor || _patch != object.patch || !(_mark == object.mark || [_mark isEqualToString:object.mark]);
}

- (BOOL)isGreaterThan:(PackageVersion *)object {
    if (_major > object.major) return YES;
    else if (_major < object.major) return NO;
    
    else /* if _major == object.major */ {
        
        if (_minor > object.minor) return YES;
        else if (_minor < object.minor) return NO;
        
        else /* if _minor == object.minor */ {
            
            if (_patch > object.patch) return YES;
            else if (_patch < object.patch) return NO;
            
            else /* if _patch == object.patch */ {
                NSUInteger
                    len1 = _mark.length,
                    len2 = object.mark.length;
                
                for (NSUInteger i = 0; i < len1 && i < len2; i++) {
                    unichar
                        c1 = [_mark characterAtIndex:i],
                        c2 = [object.mark characterAtIndex:i];
                    
                    // eg. 1.2.0b > 1.2.0a is true
                    if (c1 != c2) return c1 > c2;
                }
                
                // eg. 1.2.0 > 1.2.0a
                if (len1 == 0) return YES;
                if (len2 == 0) return NO;
                
                // eg. 1.2.0rc2 > 1.2.0rc
                return len1 > len2;
            }
        }
    }
}

- (BOOL)isGreaterThanOrEqualTo:(PackageVersion *)object {
    if (_major > object.major) return YES;
    else if (_major < object.major) return NO;
    
    else /* if _major == object.major */ {
        
        if (_minor > object.minor) return YES;
        else if (_minor < object.minor) return NO;
        
        else /* if _minor == object.minor */ {
            
            if (_patch > object.patch) return YES;
            else if (_patch < object.patch) return NO;
            
            else /* if _patch == object.patch */ {
                NSUInteger
                    len1 = _mark.length,
                    len2 = object.mark.length;
                
                for (NSUInteger i = 0; i < len1 && i < len2; i++) {
                    unichar
                        c1 = [_mark characterAtIndex:i],
                        c2 = [object.mark characterAtIndex:i];
                    
                    if (c1 != c2) return c1 > c2;
                }
                
                // eg. 1.2.0 > 1.2.0a
                if (len1 == 0) return YES;
                if (len2 == 0) return NO;
                
                // eg. 1.2.0rc2 > 1.2.0rc
                return len1 >= len2;
            }
        }
    }
}

- (BOOL)isLessThan:(PackageVersion *)object {
    return [object isGreaterThan:self];
}

- (BOOL)isLessThanOrEqualTo:(PackageVersion *)object {
    return [object isGreaterThanOrEqualTo:self];
}

@end
