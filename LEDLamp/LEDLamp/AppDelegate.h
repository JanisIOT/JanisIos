//
//  AppDelegate.h
//  LEDLamp
//
//  Created by Camilo  on 10/6/15.
//  Copyright © 2015 Camilo . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property(nonatomic,strong) MBProgressHUD *hud;

-(void) showLoadingIndicator;


-(void) hideLoadingIndicator;
@end

