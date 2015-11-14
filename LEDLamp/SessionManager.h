//
//  SessionManager.h
//  ExpertoAntirrobo
//
//  Created by Meridian Group on 9/10/14.
//  Copyright (c) 2014 Meridian Group. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MSWeakTimer.h"


#define up 1
#define down 2

@interface SessionManager : NSObject
+ (SessionManager *)sharedInstance;

@property (strong, nonatomic) NSUserDefaults *appStates;
@property (strong, nonatomic) NSDictionary *properties;

/**
 */
@property (nonatomic, strong) NSMutableArray *newsMeridian;
@property (nonatomic, strong) NSString *urlReceived;
@property (nonatomic, assign) BOOL isNewOrder;
@property (nonatomic, strong) NSDictionary *menuData;
@property (nonatomic, strong) NSString *restaurantId;
@property (nonatomic, strong) NSString *tableId;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *ssid;

-(BOOL)introWasShown;
-(void) setIntroShown:(BOOL)wasShown;
-(NSSet *) getPassedStories;
-(void) setPassedStories:(NSSet *)passed;
-(BOOL)isMenuEnabled;
-(void)enableMenu:(BOOL )disable;

-(NSSet *) getUserConfig;
-(void) setUserConfig:(NSSet *)u_config;

-(NSString*)getIP;
-(void)setIP:(NSString* )IP;

-(NSString*)getISSID;
-(void)setSSID:(NSString* )SSID;

@end
