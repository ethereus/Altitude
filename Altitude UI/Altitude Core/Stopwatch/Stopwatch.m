//
//  Stopwatch.m
//  Altitude Core
//
//  Created by Dara on 16/08/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import "Stopwatch.h"

@interface Stopwatch ()

@property struct timespec startingTime;

@end

@implementation Stopwatch

- (instancetype)init {
    clock_gettime(CLOCK_MONOTONIC, &self->_startingTime);
    return self;
}

- (void)restart {
    clock_gettime(CLOCK_MONOTONIC, &_startingTime);
}

- (double)timeElapsed {
    struct timespec end;
    clock_gettime(CLOCK_MONOTONIC, &end);
    
    time_t s_elapsed = end.tv_sec - _startingTime.tv_sec;
    time_t n_elapsed = end.tv_nsec - _startingTime.tv_nsec;
    return s_elapsed + n_elapsed / 1000000000.;
}

@end
