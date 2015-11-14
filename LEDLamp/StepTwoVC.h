//
//  StepTwoVC.h
//  LEDLamp
//
//  Created by Camilo  on 10/12/15.
//  Copyright © 2015 Camilo . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICoAPExchange.h"
#import "MGHelpers.h"
#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
@interface StepTwoVC : UIViewController<ICoAPExchangeDelegate>{
    ICoAPExchange *iExchange;
    NSDateFormatter *completeDateFormat;
}

@property (strong, nonatomic) IBOutlet UITextField *tv_name;
@property (strong, nonatomic) IBOutlet UIImageView *im_janis;
@property (strong, nonatomic) IBOutlet UIButton *bt_next;

@property (strong, nonatomic) IBOutlet UILabel *tv_net_name;
@property (strong, nonatomic) IBOutlet UITextField *tv_pass;
- (IBAction)ssid:(id)sender;
- (IBAction)pass:(id)sender;
- (IBAction)control:(id)sender;
@end
