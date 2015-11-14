//
//  ViewController.h
//  LEDLamp
//
//  Created by Camilo  on 10/6/15.
//  Copyright © 2015 Camilo . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICoAPExchange.h"
#import "MGHelpers.h"
#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "SessionManager.h"
#import "NEOColorPickerBaseViewController.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
@interface StepOne_VC : NEOColorPickerBaseViewController<ICoAPExchangeDelegate>{
    ICoAPExchange *iExchange;
    NSDateFormatter *completeDateFormat;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *hueImageView;
@property (weak, nonatomic) IBOutlet UIImageView *hueCrosshair;
@property (strong, nonatomic) IBOutlet UIImageView *im_janis;

@property (strong, nonatomic) IBOutlet UIButton *bt_next;
- (void)startTimer;
- (void)cancelTimer;
-(void)colors :(UIColor*)color;
- (IBAction)next:(id)sender;

@end

