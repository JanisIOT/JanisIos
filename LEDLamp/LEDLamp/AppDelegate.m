//
//  AppDelegate.m
//  LEDLamp
//
//  Created by Camilo  on 10/6/15.
//  Copyright © 2015 Camilo . All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "SessionManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize hud;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SessionManager sharedInstance] setIp:@"192.168.4.1"];
    [Fabric with:@[[Crashlytics class]]];

    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) showLoadingIndicator
{
    if ( hud != nil )
    {
        [self hideLoadingIndicator];
    }
    
    UIView *view=[[UIApplication sharedApplication] keyWindow];
    if(!view)
        view=[[[UIApplication sharedApplication] delegate] window];
    if(!view)
        return;
    
    hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    
    //self.hud.dimBackground = YES;
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud setLabelText:@"Buscando a Janis"];
    
    [hud show:YES];
}



-(void) hideLoadingIndicator
{
    [hud hide:YES];
    [hud removeFromSuperview];
    hud = nil;
}

@end
