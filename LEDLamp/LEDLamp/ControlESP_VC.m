//
//  NEOColorPickerViewController.m
//
//  Created by Karthik Abram on 10/10/12.
//  Copyright (c) 2012 Neovera Inc.
//


/*
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */


#import "ControlESP_VC.h"
#import "UIColor+NEOColor.h"
#import <QuartzCore/QuartzCore.h>


#define CP_RESOURCE_CHECKERED_IMAGE                     @"colorPicker.bundle/color-picker-checkered"
#define CP_RESOURCE_HUE_CIRCLE                          @"colorPicker.bundle/color-picker-hue"
#define CP_RESOURCE_HUE_CROSSHAIR                       @"colorPicker.bundle/color-picker-crosshair"
#define CP_RESOURCE_VALUE_MAX                           @"colorPicker.bundle/color-picker-max"
#define CP_RESOURCE_VALUE_MIN                           @"colorPicker.bundle/color-picker-min"


@interface ControlESP_VC () 
{
    CALayer *_colorLayer;
    CGFloat _hue, _saturation, _luminosity, _alpha;
}
@end

@implementation ControlESP_VC

-(void) changeNavigationBarTitle:(NSString *) title{
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    self.title = [title uppercaseString];
    [self.navigationController setTitle:[title uppercaseString]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationBarTitle:@"JANIS"];
    
    NSString *ip_saved=[[SessionManager sharedInstance] getIP];
    if(ip_saved.length>0){
        [self setupNavBar];
    }
    
    
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = HEXCOLOR(0x00A9FF);
        self.navigationController.navigationBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = HEXCOLOR(0x00A9FF);
    }
    if (self.selectedColor == nil) {
        self.selectedColor = [UIColor redColor];
    }
    
    self.hueImageView.image = [UIImage imageNamed:CP_RESOURCE_HUE_CIRCLE];
    
    self.hueImageView.layer.zPosition = 10;
    
    
    self.hueCrosshair.image = [UIImage imageNamed:CP_RESOURCE_HUE_CROSSHAIR];
    self.hueCrosshair.layer.zPosition = 15;
    
    
    [[self.selectedColor neoToHSL] getHue:&_hue saturation:&_saturation brightness:&_luminosity alpha:&_alpha];
    if (self.disallowOpacitySelection) {
        _alpha = 1.0;
    }
    
    [self valuesChanged];
    
    // Position hue cross-hair.
    [self positionHue];
    
    self.hueImageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(huePanOrTap:)];
    [self.hueImageView addGestureRecognizer:panRecognizer];
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(huePanOrTap:)];
//    [self.hueImageView addGestureRecognizer:tapRecognizer];
    
        
   
}


- (void) positionHue {
    //CGFloat offset = (ViewWidth(self.hueImageView)*0.33f);
    CGFloat angle = M_PI * 2 * _hue - M_PI;
    //CGFloat cx = (76 * cos(angle) +160 + offset )- 16.5;
    CGFloat cx = 76 * cos(angle) +160 - 16.5;
    CGFloat cy = 76 * sin(angle) + 90 + self.hueImageView.frame.origin.y - 16.5;
    CGRect frame = self.hueCrosshair.frame;
    frame.origin.x = cx;
    frame.origin.y = cy;
    self.hueCrosshair.frame = frame;
}


- (void) valuesChanged {
    [self positionHue];
    
    
    self.selectedColor = [UIColor colorWithHue:_hue saturation:_saturation brightness:_luminosity alpha:_alpha];
    
    _colorLayer.backgroundColor = self.selectedColor.CGColor;
    [self colors:self.selectedColor];
    [self.im_janis setBackgroundColor:self.selectedColor];
    [_colorLayer setNeedsDisplay];
    
    

    if ([self.delegate respondsToSelector:@selector(colorPickerViewController:didChangeColor:)]) {
        [self.delegate colorPickerViewController:self didChangeColor:self.selectedColor];
    }
}
-(uint8_t)red:(int) color {
    uint8_t red = (color & 0x00ff0000) >> 16;
    return red;
}
-(uint8_t) green:(int) color {
    uint8_t green = (color & 0x0000ff00) >> 8;
    return green;
}

-( uint8_t) blue:(int) color {
    uint8_t blue = (color & 0x000000ff);
    return blue;
}

- (NSUInteger)colorCode:(UIColor*) color {
    CGFloat red, green, blue;
    if ([color getRed:&red green:&green blue:&blue alpha:NULL])
    {
        NSUInteger redInt = (NSUInteger)(red * 255 + 0.5);
        NSUInteger greenInt = (NSUInteger)(green * 255 + 0.5);
        NSUInteger blueInt = (NSUInteger)(blue * 255 + 0.5);
        
        
        
        return (redInt << 16) | (greenInt << 8) | blueInt;
    }
    
    return 0;
}

-(void)colors :(UIColor*)colorPicked{
    
    int color=[self colorCode:colorPicked];
    uint8_t r=[self red:color];
    uint8_t g=[self green:color];
    uint8_t b=[self blue:color];
    
    //NSLog(@"R = %d G = %d B = %d",r,g,b);
    uint8_t lights=16;
    uint8_t i=0;
    uint8_t jump=i*3;
    NSMutableString *str=[@"" mutableCopy];
    
    [str appendFormat:@"%02X", g ];
    [str appendFormat:@"%02X", r ];
    [str appendFormat:@"%02X", b ];
    [str appendFormat:@"%02X", lights ];
    //for( i = 0; i < lights; i++ ){
    //    jump=i*3;
        
        
    //}
    if(str&&str.length>0){
        NSString *ip_saved=[[SessionManager sharedInstance] getIP];
        if(ip_saved.length>0){
            //NSLog(@" len=%d payload=%@ %@ ",str.length,str,ip_saved);
            ICoAPMessage *cO = [[ICoAPMessage alloc] initAsRequestConfirmable:YES requestMethod:IC_GET sendToken:YES payload:str];
            [cO addOption:IC_URI_PATH withValue:@"rgb"];
            if (!iExchange) {
                iExchange = [[ICoAPExchange alloc] initAndSendRequestWithCoAPMessage:cO toHost:ip_saved port:5683 delegate:self];
            }
            else {
                [iExchange sendRequestWithCoAPMessage:cO toHost:ip_saved port:5683];
            }
        }
        
    }
    else{
        //NSLog(@"BAD DAYS");
    }
}


- (void)viewDidUnload {
    _colorLayer = nil;
    [self setHueCrosshair:nil];
    [super viewDidUnload];
}


- (void) huePanOrTap:(UIGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded: {
            CGPoint point = [recognizer locationInView:self.hueImageView];
            CGFloat dx = point.x - 90;
            CGFloat dy = point.y - 90;
            CGFloat angle = atan2f(dy, dx);
            if (dy != 0) {
                angle += M_PI;
                _hue = angle / (2 * M_PI);
            } else if (dx > 0){
                _hue = 0.5;
            }
            [self valuesChanged];
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            
            break;
        }
        default: {
            // Canceled or error state.
            break;
        }
    }
}


-(void) setupNavBar {
    //[self.navigationItem setHidesBackButton:NO];
    UIButton *btn_back= [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 46.0, 46.0)];
    
    [btn_back setImage:[UIImage imageNamed:@"Icon.png"]     forState:UIControlStateNormal];
    [btn_back setImage:[UIImage imageNamed:@"Icon.png"]  forState:UIControlStateSelected];
    [btn_back setImage:[UIImage imageNamed:@"Icon.png"]  forState:UIControlStateHighlighted];
    //        [btn_back setBackgroundImage:IMG(@"bt_common_back_off.png") forState:UIControlStateNormal ];
    //        [btn_back setBackgroundImage:IMG(@"bt_common_back_on.png") forState:UIControlStateSelected ];
    //        [btn_back setBackgroundImage:IMG(@"bt_common_back_on.png") forState:UIControlStateHighlighted ];
    /* [btn_back setTitle:@"Menu" forState:UIControlStateNormal];
     [btn_back setTitle:@"Menu" forState:UIControlStateSelected];
     [btn_back setTitle:@"Menu" forState:UIControlStateHighlighted];
     
     [btn_back setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     [btn_back setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
     [btn_back setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];*/
    
    UIBarButtonItem *item_back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuicon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButton:)];
    UIBarButtonItem *itemReset = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleBordered target:self action:@selector(reset)];
    //        [btn_back addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self.navigationItem setLeftBarButtonItems:@[item_back] animated:NO];
    [self.navigationItem setLeftItemsSupplementBackButton:YES];
    
    [self.navigationItem setRightBarButtonItems:@[itemReset] animated:NO];
}


-(void) backButton:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"open" object:nil];
}

-(void)reset{
    
    long threadIdentifier;
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        threadIdentifier = DISPATCH_QUEUE_PRIORITY_DEFAULT;
    } else {
        threadIdentifier = QOS_CLASS_USER_INITIATED;
    }
    
   
        if([[SessionManager sharedInstance] getIP].length>0){
            ICoAPMessage *cO = [[ICoAPMessage alloc] initAsRequestConfirmable:YES requestMethod:IC_GET sendToken:YES payload:nil];
            [cO addOption:IC_URI_PATH withValue:@"erase"];
            if (!iExchange) {
                iExchange = [[ICoAPExchange alloc] initAndSendRequestWithCoAPMessage:cO toHost:[[SessionManager sharedInstance] ip] port:5683 delegate:self];
            }
            else {
                [iExchange sendRequestWithCoAPMessage:cO toHost:[[SessionManager sharedInstance] ip] port:5683];
            }
        }
        [[SessionManager sharedInstance] setIP:nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [NotificationCenter postNotificationName:@"openWizard" object:self userInfo:nil];
            
        });
    //});
    
    
}



@end