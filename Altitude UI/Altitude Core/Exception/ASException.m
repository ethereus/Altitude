//
//  ASException.m
//  Altitude Core
//
//  Created by Dara on 27/11/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "ASException.h"

@interface ASException ()

@property (copy) NSString *reasonStorage;

@end

@implementation ASException

+ (instancetype)init {
    ASException *ex = super.init;
    ex.reasonStorage = NSString.new;
    
    return ex;
}

+ (instancetype)exceptionWithType:(ASExceptionType)type reason:(NSString *)reason {
    
    ASException *ex = ASException.new;
    
    ex.reason = reason;
    
    return ex;
}

- (NSString *)reason {
    return _reasonStorage.copy;
}

- (void)setReason:(NSString *)reason {
    _reasonStorage = reason.copy;
}

@end
