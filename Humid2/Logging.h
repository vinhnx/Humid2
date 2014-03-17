//
//  Logging.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#ifndef Humid2_Logging_h
#define Humid2_Logging_h

#import "DDTTYLogger.h"
#import <NXVLogFormatter/NXVLogFormatter.h>

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define NSLog DDLogInfo

#endif
