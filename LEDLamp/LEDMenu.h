//
//  ViewController.h
//  Restaurant
//
//  Created by SergioDan on 8/30/15.
//  Copyright (c) 2015 SergioDan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SASlideMenu/SASlideMenuDelegate.h>
#import <SASlideMenu/SASlideMenuDataSource.h>
#import <SASlideMenu/SASlideMenuViewController.h>


@interface LEDMenu: SASlideMenuViewController <SASlideMenuDataSource, SASlideMenuDelegate>

@property (nonatomic, assign) BOOL menuActive;
@end

