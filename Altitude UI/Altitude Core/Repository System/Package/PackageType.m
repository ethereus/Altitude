//
//  PackageType.m
//  Altitude Core
//
//  Created by Dara on 07/09/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "PackageType.h"

NSString *PackageTypeDescription(PackageType type) {
    switch (type) {
        case PackageTypeApplication: return @"APPLICATION";
        case PackageTypeTweak: return @"TWEAK";
        case PackageTypeTheme: return @"THEME";
        case PackageTypeRunCommand: return @"RUN_COMMAND";
        default: return @"UNKNOWN";
    }
}

PackageType PackageTypeWithString(NSString *t) {
    PackageType type;
    
    if ([t isEqualToString:@"APPLICATION"])
        type = PackageTypeApplication;
    else if ([t isEqualToString:@"TWEAK"])
        type = PackageTypeTweak;
    else if ([t isEqualToString:@"THEME"])
        type = PackageTypeTheme;
    else if ([t isEqualToString:@"RUN_COMMAND"])
        type = PackageTypeRunCommand;
    else
        type = PackageTypeUnknown;
    
    return type;
}
