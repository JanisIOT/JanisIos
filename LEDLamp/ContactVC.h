//
//  ContactVC.h
//  LEDLamp
//
//  Created by Camilo  on 10/15/15.
//  Copyright © 2015 Camilo . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICoAPExchange.h"
@interface ContactVC : UIViewController<ICoAPExchangeDelegate>
{
    ICoAPExchange *iExchange;
    NSDateFormatter *completeDateFormat;
    
}

@end
