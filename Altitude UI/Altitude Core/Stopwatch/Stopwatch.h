//
//  Stopwatch.h
//  Altitude Core
//
//  Created by Dara on 16/08/2018.
//  Copyright © 2018 Naqua Darazaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol StopwatchJSExport <JSExport>

// var stopwatch = new objc.Stopwatch
- (instancetype)init;
// stopwatch.restart()
- (void)restart;
// stopwatch.timeElapsed
@property (readonly, nonatomic) double timeElapsed;

@end

@interface Stopwatch : NSObject <StopwatchJSExport>

/// Create a new instance of a Stopwatch with current time
- (instancetype)init;

/// Set current time as the new starting time
- (void)restart;

/// Return the elapsed time in seconds since the starting time of this stopwatch
@property (readonly, nonatomic) double timeElapsed;

@end

NS_ASSUME_NONNULL_END
