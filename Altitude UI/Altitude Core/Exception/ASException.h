//
//  ASException.h
//  Altitude Core
//
//  Created by Dara on 27/11/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "../SharedMacros.h"
#import "ASExceptionType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASException : NSException

@property ASExceptionType type;

+ (instancetype)exceptionWithType:(ASExceptionType)type reason:(NSString *)reason;

- (NSString *)reason;
- (void)setReason:(NSString *)reason;

@end

NS_ASSUME_NONNULL_END
