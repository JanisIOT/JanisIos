//
//  MGHelpers.h
//
//  Created by Meridian Group on 9/9/14.
//  Copyright (c) 2014 Meridian Group. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import "AppDelegate.h"

NSString* AR_SHA1HashOf(NSString *str);
NSString* AR_MD5HashOf(NSString *str);
#pragma mark -
#pragma mark objectshelp
/* Some object helpers */
#define NSNUMBER_INT( _int )    [NSNumber numberWithInt: _int ]
#define NSNUMBER_BOOL( _bl  )   [NSNumber numberWithBool: _bl ]
#define NSNUMBER_FLOAT( _flt )  [NSNUmber numberWithFloat: _flt ]
#define NSNUMBER_DOUBLE( _dbl ) [NSNumber numberWithDouble: _dbl ]
#define NSNUMBER_LLONG( _ll  )  [NSNumber numberWithLongLong: _ll ]

#define NSSTRING( _fmt, _args... )  [NSString stringWithFormat: _fmt, ##_args ]

#define GET_BOOL_IMMEDIATE( _dic, _key )            [[ _dic objectForKey: _key ] boolValue]
#define GET_LONG_IMMEDIATE( _dic, _key )            [[ _dic objectForKey: _key ] longValue]
#define GET_LONGLONG_IMMEDIATE( _dic, _key )        [[ _dic objectForKey: _key ] longLongValue]
#define GET_DOUBLE_IMMEDIATE( _dic, _key )          [[ _dic objectForKey: _key ] doubleValue]
#define GET_STRING_IMMEDIATE( _dic, _key )          [ _dic objectForKey: _key ]
#define GET_OBJ_IMMEDIATE( _dic, _key )             [ _dic objectForKey: _key ]

BOOL GET_BOOL_AR(NSDictionary *dic, NSString *key);
long GET_LONG_AR(NSDictionary *dic, NSString *key);
long long GET_LONGLONG_AR(NSDictionary *dic, NSString *key);
double GET_DOUBLE_AR(NSDictionary *dic, NSString *key);
NSString* GET_STRING_AR(NSDictionary *dic, NSString *key);
id GET_OBJ_AR(NSDictionary *dic, NSString *key);

#define PROTECTED_SET_OBJ( _dic, _key, _val )  do { if ( _val ) [ _dic setObject: _val forKey: _key ]; else [ _dic removeObjectForKey: _key ]; } while (0)

#define SET_BOOL( _dic, _key, _val )      [ _dic setObject:[NSNumber numberWithBool: _val ] forKey: _key ]
#define SET_LONG( _dic, _key, _val )      [ _dic setObject:[NSNumber numberWithLong: _val ] forKey: _key ]
#define SET_LONGLONG( _dic, _key, _val )  [ _dic setObject:[NSNumber numberWithLongLong: _val ] forKey: _key ]
#define SET_DOUBLE( _dic, _key, _val )    [ _dic setObject:[NSNumber numberWithDouble: _val ] forKey: _key ]
#define SET_STRING( _dic, _key, _val )    PROTECTED_SET_OBJ( _dic, _key, _val )
#define SET_OBJ( _dic, _key, _val )       PROTECTED_SET_OBJ( _dic, _key, _val )

#define SET_STRING_IMMEDIATE( _dic, _key, _val )              [ _dic setObject: _val forKey: _key ]
#define SET_OBJ_IMMEDIATE( _dic, _key, _val )                 [ _dic setObject: _val forKey: _key ]

#define LTONSA( _long )  [NSString stringWithFormat:@"%ld", _long ]
#define LLTONSA( _long ) [NSString stringWithFormat:@"%lld", _long ]
//#define removeObserverKey (_owner, _key ) [[NSNotificationCenter defaultCenter] removeObserver:_owner name:_key object:nil];
//#define removeObserver (_owner, ) [[NSNotificationCenter defaultCenter] removeObserver:_owner ];
#pragma mark -
#pragma mark Location
/* Location */
extern CLLocation *gps_MTCurrentLocation;


#pragma mark -
#pragma mark Bookmark keys
/* Bookmark keys*/
#define FIELDNOTPRESENT             -9999
#define LASTPLAYEDSTATION_SERVER    @"lastPlayedStation"
#define LASTPLAYEDSTATION_LOCAL     @"last_played_station"
#define LASTPLAYEDSTATIONTIMESTAMP_SERVER   @"lastPlayedStationDate"
#define LASTPLAYEDSTATIONTIMESTAMP_LOCAL   @"last_played_station_date"
#define LASTPLAYEDCONTENT_SERVER            @"lastPlayedContent"
#define LASTPLAYEDCONTENT_LOCAL             @"last_played_content"
#define LASTPLAYEDCONTENTTIMESTAMP_SERVER   @"lastPlayedContentDate"
#define LASTPLAYEDCONTENTIMESTAMP_LOCAL     @"last_played_content_date"
#define ELAPSEDTIME_LOCAL                   @"elapsed_time"
#define ELAPSEDBYTES_LOCAL                  @"elapsed_bytes"
#define ELAPSEDTIMESTAMP_SERVER             @"elapsedTimestamp"
#define ELAPSEDTIMESTAMP_LOCAL              @"elapsed_timestamp"

#pragma mark -
#pragma mark URLKeys
/*Server URL Keys*/
#define kAhaRadioServerUrlKey           @"AhaRadioServerUrl"


#pragma mark -
#pragma mark usefullmacros
/* userfull Macros*/
#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define NotificationCenter                  [NSNotificationCenter defaultCenter]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define NavBar                              self.navigationController.navigationBar
#define TabBar                              self.tabBarController.tabBar
#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define TouchHeightDefault                  44
#define TouchHeightSmall                    32
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewWidth                       self.view.bounds.size.width
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define NSRect(r)                           NSStringFromCGRect(r)
#define Frame(x,y,w,h)                      CGRectMake(x, y, w, h)
#define DATE_COMPONENTS                     NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
#define TIME_COMPONENTS                     NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define FlushPool(p)                        [p drain]; p = [[NSAutoreleasePool alloc] init]
#define IMG(i)                              [UIImage imageNamed:i]
#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXCOLOR(c)                         [UIColor colorWithRed:((float)((c & 0xFF0000) >> 16))/255.0 green:((float)((c & 0xFF00) >> 8))/255.0 blue:((float)(c & 0xFF))/255.0 alpha:1.0]
#define HEXCOLORA(c,a)                         [UIColor colorWithRed:((float)((c & 0xFF0000) >> 16))/255.0 green:((float)((c & 0xFF00) >> 8))/255.0 blue:((float)(c & 0xFF))/255.0 alpha:a]

/*
 *  Geometry
 */
#pragma mark -
#pragma mark Geometry
#define DEG_TO_RAD(degrees) ((degrees) * M_PI / 180.0)
#define RAD_TO_DEG(radians) ((radians) * 180.0 / M_PI)

/*
 *  Strings
 */
#pragma mark -
#pragma mark Strings
#define	NSLS(str)   NSLocalizedString(str, nil)

#define IS_EMPTY_STRING(str)            (!(str) || ![(str) isKindOfClass:NSString.class] || [(str) length] == 0)
#define IS_POPULATED_STRING(str)        ((str) && [(str) isKindOfClass:NSString.class] && [(str) length] > 0)

/*
 *  Arrays
 */
#pragma mark -
#pragma mark Arrays
#define IS_EMPTY_ARRAY(arr)             (!(arr) || ![(arr) isKindOfClass:NSArray.class] || [(arr) count] == 0)
#define IS_POPULATED_ARRAY(arr)         ((arr) && [(arr) isKindOfClass:NSArray.class] && [(arr) count] > 0)

/*
 *  Dictionaries
 */
#pragma mark -
#pragma mark Dictionaries
#define IS_EMPTY_DICTIONARY(dic)        (!(dic) || ![(dic) isKindOfClass:NSDictionary.class] || [(dic) count] == 0)
#define IS_POPULATED_DICTIONARY(dic)    ((dic) && [(dic) isKindOfClass:NSDictionary.class] && [(dic) count] > 0)

/*
 *  Colors
 */
#pragma mark -
#pragma mark Colors
#define RGB_SINGLE(col) ((col) / 255.0f)
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/*
 *  Hardware / Device info
 */
#pragma mark -
#pragma mark Device hardware
#define UI_IPAD         ( [ UIDevice currentDevice ].userInterfaceIdiom == UIUserInterfaceIdiomPad )
#define UI_IPHONE       ( [ UIDevice currentDevice ].userInterfaceIdiom == UIUserInterfaceIdiomPhone )
#define UI_WIDESCREEN   ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPHONE       ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD         ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPAD         ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPad" ] )

#define CAN_CALL        ( [ [ UIApplication sharedApplication ] canOpenURL: [ NSURL URLWithString: @"tel://" ] ] )

/*
 *  Screen / Display
 */
#pragma mark -
#pragma mark Screen- Display

#define IS_DEVICE_ORIENTATION_PORTRAIT(orientation)     ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)
#define IS_DEVICE_ORIENTATION_LANDSCAPE(orientation)    ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)

#define IS_DEVICE_ORIENTATION_FACE_UP                   ([UIDevice currentDevice].orientation == UIDeviceOrientationFaceUp)
#define IS_DEVICE_ORIENTATION_FACE_DOWN                 ([UIDevice currentDevice].orientation == UIDeviceOrientationFaceDown)

#define HARDWARE_SCREEN_WIDTH                           ([UIScreen mainScreen].bounds.size.width)
#define HARDWARE_SCREEN_HEIGHT                          ([UIScreen mainScreen].bounds.size.height)

/*
 *  System Versioning
 */

#pragma mark -
#pragma mark System version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/*
 *  Exceptions
 */
#pragma mark -
#pragma mark Exceptions
#define kArgumentException @"ArgumentException"
#define kArgumentNilException @"ArgumentNilException"
#define kArgumentNilOrEmptyException @"ArgumentNilOrEmptyException"
#define kNilObjectException @"NilObjectException"
#define kInvalidOperationException @"InvalidOperationException"
#define kInvalidObjectTypeException @"InvalidObjectTypeException"
#define kNotImplementedException @"NotImplementedException"
#define kOutOfRangeException @"OutOfRangeException"

#define AssertIndexInRange(parameter, parameterName, min, max) if (parameter < min || parameter > max) { \
@throw [NSException exceptionWithName:kOutOfRangeException \
reason:[NSString stringWithFormat:@"%s, %d -> the parameter '%@' with value %d is out of bounds [%d .. %d].", __FUNCTION__, __LINE__, parameterName, parameter, min, max] \
userInfo:nil]; }

#define AssertIndexLessThan(parameter, parameterName, max) if (parameter >= max) { \
@throw [NSException exceptionWithName:kOutOfRangeException \
reason:[NSString stringWithFormat:@"%s, %d -> the parameter '%@' with upper bound %d has the value %d.", __FUNCTION__, __LINE__, parameterName,max, parameter] \
userInfo:nil]; }

#define AssertArgumentNotNil(argument, argumentName) if (argument == nil) { \
@throw [NSException exceptionWithName:kArgumentNilException \
reason:[NSString stringWithFormat:@"%s, %d -> the parameter %@ can not be nil.", __FUNCTION__, __LINE__, argumentName] \
userInfo:nil]; }

#define AssertArgumentNotNilOrEmptyString(argument, argumentName) if (!IS_POPULATED_STRING(argument)) { \
@throw [NSException exceptionWithName:kArgumentNilOrEmptyException \
reason:[NSString stringWithFormat:@"%s, %d -> the parameter %@ can not be nil or empty.", __FUNCTION__, __LINE__, argumentName] \
userInfo:nil]; }

#define AssertObjectNotNil(var, varName) if (var == nil) { \
@throw [NSException exceptionWithName:kNilObjectException \
reason:[NSString stringWithFormat:@"%s, %d -> the variable %@ should not be nil.", __FUNCTION__, __LINE__, varName] \
userInfo:nil]; }

#define AssertStringNonEmptyOrNil(string, argumentName) if (!IS_POPULATED_STRING(argument)) { \
@throw [NSException exceptionWithName:kArgumentException \
reason:[NSString stringWithFormat:@"%s, %d -> the parameter %@ can not be empty or nil.", __FUNCTION__, __LINE__, argumentName] \
userInfo:nil]; }

#define AssertObjectConformsProtocol(obj, objName, protocol) if (![obj conformsToProtocol:protocol]) { \
@throw [NSException exceptionWithName:kInvalidOperationException \
reason:[NSString stringWithFormat:@"%s, %d -> object %@ should conforms to the protocol %@.", __FUNCTION__, __LINE__, objName, protocol] \
userInfo:nil]; }

#define AssertObjectIsKindOfClass(obj, objName, requiredType) if (![obj isKindOfClass:[requiredType class]]) { \
@throw [NSException exceptionWithName:kInvalidObjectTypeException \
reason:[NSString stringWithFormat:@"%s, %d -> object %@ should be of type %@. Real type is %@", __FUNCTION__, __LINE__, objName, [[requiredType class] description], [[obj class] description]] \
userInfo:nil]; }

#define THROW_NOT_IMPLEMENTED_EXCEPTION @throw [NSException exceptionWithName:kNotImplementedException reason:[NSString stringWithFormat:@"%s -> the method is not implemented.", __FUNCTION__] userInfo:nil];

@interface MGHelpers : NSObject

@end
