//
//  FileNameToPattern.m
//  Altitude Core
//
//  Created by Dara on 24/10/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "FileNameToPattern.h"

NSString *FileNameToUnzipPattern(NSString *fileName) {
    // See : https://linux.die.net/man/1/unzip
    fileName = [fileName stringByReplacingOccurrencesOfString:@"[" withString:@"[[]"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"?" withString:@"[?]"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"*" withString:@"[*]"];
    return fileName;
}
