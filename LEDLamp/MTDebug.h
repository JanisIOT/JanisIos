//
//  MTDebug.h
//  AhMTadio
//
//  Created by Jason Fieldman on 12/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Crashlytics/Crashlytics.h>

typedef enum {
	
	/* Core Model */
	MTDBGCOMP_SESSION                    = 0x00000010,
	MTDBGCOMP_USER                       = 0x00000020,
	MTDBGCOMP_CONTENT                    = 0x00000040,
	MTDBGCOMP_HELPERS                    = 0x00000080,
	
    
	/* Config */
	MTDBGCOMP_CONFIG                     = 0x20000000,
	
	/* Performance */
	MTDBGCOMP_PERFORM                    = 0x40000000,
	
	/* Any */
	MTDBGCOMP_ANY                        = 0x7FFFFFFF,
	
} MTDebugComponent;

#define MTDBGCOMP_STR_SESSION            "SESSION"
#define MTDBGCOMP_STR_USER               "USER"
#define MTDBGCOMP_STR_CONTENT            "CONTENT"
#define MTDBGCOMP_STR_HELPERS            "HELPERS"
#define MTDBGCOMP_STR_CONFIG             "CONFIG"
#define MTDBGCOMP_STR_PERFORM            "PERFORM"
#define MTDBGCOMP_STR_ANY                "ANY"



typedef enum {
	
	MTDBGLVL_EMERG    = 0,
	MTDBGLVL_ALERT    = 1,
	MTDBGLVL_CRIT     = 2,
	MTDBGLVL_ERR      = 3,
	MTDBGLVL_WMTN     = 4,
	MTDBGLVL_NOTICE   = 5,
	MTDBGLVL_INFO     = 6,
	MTDBGLVL_DBG      = 7,
	
} MTDebugLevel;

#define MTDBGLVL_STR_EMERG               "EMERG"
#define MTDBGLVL_STR_ALERT               "ALERT"
#define MTDBGLVL_STR_CRIT                "CRIT"
#define MTDBGLVL_STR_ERR                 "ERR"
#define MTDBGLVL_STR_WMTN                "WMTN"
#define MTDBGLVL_STR_NOTICE              "NOTICE"
#define MTDBGLVL_STR_INFO                "INFO"
#define MTDBGLVL_STR_DBG                 "DEBUG"


/* The global debug flags */
extern int g_MTDebugComponentsEnabled;
extern int g_MTDebugMaxDebugLevel;



#ifndef MTDEBUGENABLED

#define MTLog( _component, _level, _fmt, _fmtMTgs... )
#define MTDebuggingComponent( _component )             NO
#define MTDebuggingLevel( _level )                     NO
#define MTDebugging( _component , _level )             NO
#define MTTiming_MMTkStMTtTime()
#define MTTiming_GetElapsedTime()                      (0.0)

#else

#undef CLS_LOG

#ifdef DEBUG
#define CLS_LOG(__FORMAT__, ...) CLSNSLog((@"$ " __FORMAT__), ##__VA_ARGS__)
#else
#define CLS_LOG(__FORMAT__, ...) CLSLog((@"$ " __FORMAT__), ##__VA_ARGS__)
#endif

#define MTLog( _component, _level, _fmt, _fmtMTgs... )  do {                     \
if (!(g_MTDebugComponentsEnabled | MTDBGCOMP_##_component)) break;               \
if (MTDBGLVL_##_level > g_MTDebugMaxDebugLevel) break;                           \
NSString *pMTsedString = [NSString stringWithFormat: _fmt, ##_fmtMTgs ];         \
NSString *fullLog = [NSString stringWithFormat:@"[ %9s : %6s : %12s ] %@", MTDBGCOMP_STR_##_component , MTDBGLVL_STR_##_level , MTTiming_GetFormattedCurrentTime() ,  pMTsedString];  \
CLS_LOG(@"%@", fullLog);                                                       \
} while (0)

#define MTDebuggingComponent ( _component ) ( g_MTDebugComponentsEnabled | MTDBGCOMP_##_component )
#define MTDebuggingLevel     ( _level     ) ( MTDBGLVL_##_level <= g_MTDebugMaxDebugLevel )
#define MTDebugging  ( _component, _level ) ( MTDebuggingComponent( _component ) && MTDebuggingLevel ( _level ) )

void MTTiming_MMTkStMTtTime();
CFAbsoluteTime MTTiming_GetElapsedTime();
const char *MTTiming_GetFormattedCurrentTime(void);

#endif

#ifdef DEBUG
#   define AlertLog(fmt, ...)  { \
UIAlertView *alert = [[UIAlertView alloc] \
initWithTitle : [NSString stringWithFormat:@"%s(Line: %d) ", __PRETTY_FUNCTION__, __LINE__]\
message : [NSString stringWithFormat : fmt, ##__VA_ARGS__]\
delegate : nil\
cancelButtonTitle : @"Ok"\
otherButtonTitles : nil];\
[alert show];\
}
#else
#   define AlertLog(...)
#endif




#ifdef DEBUG
#   define MemoryLog() {\
struct task_basic_info info;\
mach_msg_type_number_t size = sizeof(info);\
kern_return_t e = task_info(mach_task_self(),\
TASK_BASIC_INFO,\
(task_info_t)&info,\
&size);\
if(KERN_SUCCESS == e) {\
NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init]; \
[formatter setNumberStyle:NSNumberFormatterDecimalStyle]; \
CLS_LOG(@"%@ bytes", [formatter stringFromNumber:[NSNumber numberWithInteger:info.resident_size]]);\
} else {\
CLS_LOG(@"Error with task_info(): %s", mach_error_string(e));\
}\
}
#else
#   define MemoryLog
#endif


