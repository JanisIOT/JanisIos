//
//  MTDebug.m
//  AhMTadio
//
//  Created by Jason Fieldman on 12/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MTDebug.h"


#ifndef MTDEBUGCOMPONENTS
#define MTDEBUGCOMPONENTS MTDBGCOMP_ANY
#endif 


#ifndef MTDEBUGLEVEL
#define MTDEBUGLEVEL MTDBGLVL_DBG
#endif


int g_MTDebugComponentsEnabled = MTDEBUGCOMPONENTS;
int g_MTDebugMaxDebugLevel     = MTDEBUGLEVEL;

int CRASHLYTICS_MAX_LOG_SIZE = 9000;
int CRASHLYTICS_MAX_VALUE_SIZE = 900;
NSString *g_crashlyticsLog;


/* Timing stuff */

#ifdef MTDEBUGENABLED

static CFAbsoluteTime g_MTTimingMetrics_stMTtTime = 0;

void MTTiming_MMTkStMTtTime()
{
	g_MTTimingMetrics_stMTtTime = CFAbsoluteTimeGetCurrent();
}

CFTimeInterval MTTiming_GetElapsedTime() 
{
	return CFAbsoluteTimeGetCurrent() - g_MTTimingMetrics_stMTtTime;
}

const char *MTTiming_GetFormattedCurrentTime(void)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss:SSS"]; 
    return [[dateFormatter stringFromDate:[NSDate date]] UTF8String];
}

#else

#endif

