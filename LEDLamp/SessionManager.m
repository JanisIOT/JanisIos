//
//  SessionManager.m
//  ExpertoAntirrobo
//
//  Created by Meridian Group on 9/10/14.
//  Copyright (c) 2014 Meridian Group. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager
@synthesize appStates;
@synthesize newsMeridian;
@synthesize properties;
@synthesize isNewOrder;
@synthesize menuData,restaurantId,tableId,ip,ssid;

+ (SessionManager *)sharedInstance
{
    // the instance of this class is stored here
    static SessionManager *manager = nil;
    
    // check to see if an instance already exists
    if (manager==nil) {
        manager  = [[[self class] alloc] init];
        [manager initSession];
        
        [manager setNewsMeridian:[@[] mutableCopy]];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"properties" ofType:@"plist"];
        [manager setProperties:[[NSDictionary alloc] initWithContentsOfFile:path]];
        
        [manager setIsNewOrder:YES];
        
        if(![manager appStates])
            [manager setAppStates:[NSUserDefaults standardUserDefaults]];
        
    }
    
    // return the instance of this class
    return manager;
}

-(void)initSession{
    appStates=[NSUserDefaults standardUserDefaults];
}

-(void)commitoperations{
    if(![appStates synchronize]){
        //NSLog(@"fail saving to storage");
    }
}


-(BOOL)introWasShown{
    BOOL wasShown=[appStates boolForKey:@"wasShown"];
    return wasShown;
}

-(void) setIntroShown:(BOOL )wasShown{
    [appStates setBool:wasShown forKey:@"wasShown"];
    [self commitoperations];
}
-(NSSet *) getPassedStories{
    NSData *receivedData=(NSData *)[appStates objectForKey:@"passed_stories"];
    NSSet *passed = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
    return passed;
}

-(void) setPassedStories:(NSSet *)passed{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:passed];
    [appStates setObject:data forKey:@"passed_stories"];
//    [appStates setValue:passed forKey:@"passed_stories"];
    [self commitoperations];
}

-(BOOL)isMenuEnabled{
    BOOL enabled=[appStates boolForKey:@"menu_enabled"];
    return enabled;
}

-(void)enableMenu:(BOOL )disable{
    [appStates setBool:disable forKey:@"menu_enabled"];
    [self commitoperations];
}

-(NSString*)getIP{
    NSString *IP=[appStates stringForKey:@"IP"];
    return IP;
}

-(void)setIP:(NSString* )IP{
    [appStates setObject:IP forKey:@"IP"];
    [self commitoperations];
}


-(NSSet *) getUserConfig{
    NSData *receivedData=(NSData *)[appStates objectForKey:@"user_config"];
    NSSet *passed = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
    return passed;
}

-(void) setUserConfig:(NSSet *)u_config{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:u_config];
    [appStates setObject:data forKey:@"userConfig"];
    //    [appStates setValue:passed forKey:@"passed_stories"];
    [self commitoperations];
}

-(NSString*)getISSID{
    NSString *SSID=[appStates stringForKey:@"SSID"];
    return SSID;
    
}
-(void)setSSID:(NSString* )SSID{
    [appStates setObject:SSID forKey:@"SSID"];
    [self commitoperations];
    
}



@end
