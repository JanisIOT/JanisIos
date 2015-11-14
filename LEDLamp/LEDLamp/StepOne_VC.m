//
//  ViewController.m
//  LEDLamp
//
//  Created by Camilo  on 10/6/15.
//  Copyright © 2015 Camilo . All rights reserved.
//

#import "StepOne_VC.h"
#import "UIColor+NEOColor.h"
#import <QuartzCore/QuartzCore.h>


#define CP_RESOURCE_CHECKERED_IMAGE                     @"colorPicker.bundle/color-picker-checkered"
#define CP_RESOURCE_HUE_CIRCLE                          @"colorPicker.bundle/color-picker-hue"
#define CP_RESOURCE_HUE_CROSSHAIR                       @"colorPicker.bundle/color-picker-crosshair"
#define CP_RESOURCE_VALUE_MAX                           @"colorPicker.bundle/color-picker-max"
#define CP_RESOURCE_VALUE_MIN                           @"colorPicker.bundle/color-picker-min"


@interface StepOne_VC ()

@end

@implementation StepOne_VC{
     dispatch_source_t _timer;
    dispatch_queue_t queue;
    
        CALayer *_colorLayer;
        CGFloat _hue, _saturation, _luminosity, _alpha;
    
    NSArray* networks;
    NSArray* a;
    NSString *newIp;
    dispatch_source_t _timerDisco;
    dispatch_source_t _timerNetwork;
    int i;

    
}

- (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.85 alpha:1.0];
    UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.7 alpha:1.0];
    UIColor *colorFour = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.4 alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.02];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.99];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

-(void) setupNavBar {
        UIButton *btn_back= [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 46.0, 46.0)];
    
    [btn_back setImage:[UIImage imageNamed:@"Icon.png"]     forState:UIControlStateNormal];
    [btn_back setImage:[UIImage imageNamed:@"Icon.png"]  forState:UIControlStateSelected];
    [btn_back setImage:[UIImage imageNamed:@"Icon.png"]  forState:UIControlStateHighlighted];
    
        UIBarButtonItem *item_back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuicon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButton:)];
    
    UIBarButtonItem *itemReset = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self action:@selector(help)];
    //        [btn_back addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.navigationItem setHidesBackButton:YES];
    
       [self.navigationItem setLeftBarButtonItems:@[item_back] animated:NO];
    [self.navigationItem setLeftItemsSupplementBackButton:YES];
    
    
    [self.navigationItem setRightBarButtonItems:@[itemReset] animated:NO];
    
}

-(void)help{
    [ApplicationDelegate showLoadingIndicator];
    [self startTimerNetwork];
}
-(void) backButton:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"open" object:nil];
}

dispatch_source_t pathfinder(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


- (void)startTimer
{
    double secondsToFire = 0.500f;
    //dispatch_queue_t queue_main = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    /*_timer = echo(secondsToFire, queue, ^{
        [self ping];
    });*/
    _timer = pathfinder(secondsToFire, queue, ^{
        [self ping];
    });
}

- (void)cancelTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)setCurrentSSID{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSString *ssid = @"Type your WIFI name";
    NSString *interfaceName=[interfaceNames objectAtIndex:0];
    NSDictionary *info = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
    if (info[@"SSID"]) {
        ssid = info[@"SSID"];
        [[SessionManager sharedInstance] setSSID:ssid];
        [[SessionManager sharedInstance] setSsid:ssid];
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self startTimer];
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [self cancelTimer];
    [iExchange setDelegate:nil];
    iExchange=nil;
}
-(void) changeNavigationBarTitle:(NSString *) title{
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    self.title = [title uppercaseString];
    [self.navigationController setTitle:[title uppercaseString]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationBarTitle:@"JANIS"];
    
    
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = HEXCOLOR(0x00A9FF);
        self.navigationController.navigationBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = HEXCOLOR(0x00A9FF);
    }
    queue = dispatch_queue_create("janis_queue", NULL);
    [self setupNavBar];
  
    [self setCurrentSSID];
    
    if (self.selectedColor == nil) {
        self.selectedColor = [UIColor redColor];
    }
    
   
    
//    CAGradientLayer *bg = [self greyGradient];
//    bg.frame = self.view.bounds;
//    [self.view.layer insertSublayer:bg atIndex:0];
    
    [super viewDidLoad];
    
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
    

    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void) positionHue {
    CGFloat offset = (ViewWidth(self.hueImageView)*0.08f);
    CGFloat angle = M_PI * 2 * _hue - M_PI;
    CGFloat cx = 76 * cos(angle) +160  - 16.5;
    CGFloat cy = 76 * sin(angle) + 90 + self.hueImageView.frame.origin.y - 16.5;
    CGRect frame = self.hueCrosshair.frame;
    frame.origin.x = cx;
    frame.origin.y = cy;
    self.hueCrosshair.frame = frame;
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
       // NSLog(@" len=%d payload=%@ %@ ",str.length,str,[[SessionManager sharedInstance] ip]);
        ICoAPMessage *cO = [[ICoAPMessage alloc] initAsRequestConfirmable:YES requestMethod:IC_GET sendToken:YES payload:str];
        [cO addOption:IC_URI_PATH withValue:@"rgb"];
        if (!iExchange) {
            iExchange = [[ICoAPExchange alloc] initAndSendRequestWithCoAPMessage:cO toHost:@"192.168.4.1" port:5683 delegate:self];
        }
        else {
            [iExchange sendRequestWithCoAPMessage:cO toHost:@"192.168.4.1" port:5683];
        }
    }
    else{
        //NSLog(@"BAD DAYS");
    }
}

- (IBAction)next:(id)sender {
    
   NSString * ssid=[self getCurrentSSID] ;
    
    if(ssid&& ([ssid rangeOfString:@"JANIS"].location!=NSNotFound) ){
        [self.bt_next setBackgroundColor:[UIColor redColor]];
        
        [self performSegueWithIdentifier:@"connected" sender:self];
        
        [self.bt_next setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Proximante podras configurar a Janis en tu red!"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok",nil];
        [alert show];
        
        
    }
    
   
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)getCurrentSSID{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSString *ssid = @"Type your WIFI name";
    NSString *interfaceName=[interfaceNames objectAtIndex:0];
    NSDictionary *info = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
    if (info[@"SSID"]) {
        ssid = info[@"SSID"];
        
        return ssid;
    }
    return nil;
}

- (void)startTimerDiscovery
{
    double secondsToFire = 0.20f;
    //dispatch_queue_t queue_main = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timerDisco = pathfinder(secondsToFire, queue, ^{
        newIp =[@"" stringByAppendingFormat:@"%@.%@.%@.%d",[a objectAtIndex:0],[a objectAtIndex:1], [a objectAtIndex:2],i];
        i++;
        //NSLog(@"ping on ip %@", newIp);
        [self disco:newIp];
        if(i>=255){
            [ApplicationDelegate hideLoadingIndicator];
            
            [self cancelTimerDisco];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No hemos encontrado a Janis. intenta nuevamente"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok",nil];
            [alert show];
            

            i=0;
            
        }
    });
}

- (void)startTimerNetwork
{
    double secondsToFire = 0.30f;
    //dispatch_queue_t queue_main = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timerNetwork = pathfinder(secondsToFire, queue, ^{
        
        a = [[self getIPAddress] componentsSeparatedByString: @"." ];
        if(a.count==4){
            newIp=nil;
            i=0;
            [self startTimerDiscovery];
            [self cancelTimerNet];
            
        }
    });
}

- (void)cancelTimerNet
{
    if (_timerNetwork) {
        dispatch_source_cancel(_timerNetwork);
        _timerNetwork = nil;
    }
}

- (void)cancelTimerDisco
{
    if (_timerDisco) {
        dispatch_source_cancel(_timerDisco);
        _timerDisco = nil;
    }
}

-(void)disco:(NSString*)host{
    ICoAPMessage *cO = [[ICoAPMessage alloc] initAsRequestConfirmable:YES requestMethod:IC_GET sendToken:YES payload:nil];
    [cO addOption:IC_URI_PATH withValue:@"disco"];
    if (!iExchange) {
        iExchange = [[ICoAPExchange alloc] initAndSendRequestWithCoAPMessage:cO toHost:host port:5683 delegate:self];
    }
    else {
        [iExchange sendRequestWithCoAPMessage:cO toHost:host port:5683];
    }
    
}
-(void)ping{
        //NSLog(@"Ping");
        ICoAPMessage *cO = [[ICoAPMessage alloc] initAsRequestConfirmable:YES requestMethod:IC_GET sendToken:YES payload:nil];
        [cO addOption:IC_URI_PATH withValue:@"ping"];
        if (!iExchange) {
            iExchange = [[ICoAPExchange alloc] initAndSendRequestWithCoAPMessage:cO toHost:@"192.168.4.1" port:5683 delegate:self];
        }
        else {
            
            [iExchange sendRequestWithCoAPMessage:cO toHost:@"192.168.4.1" port:5683];
        }
   
}

- (void)iCoAPExchange:(ICoAPExchange *)exchange didReceiveCoAPMessage:(ICoAPMessage *)coapMessage {
    
    if([coapMessage.payload isEqualToString:@"1"]){
        [ApplicationDelegate hideLoadingIndicator];
        [[SessionManager sharedInstance] setIP:newIp];
        [[SessionManager sharedInstance] setIp:newIp];
        [self cancelTimerDisco];
        dispatch_async(dispatch_get_main_queue(), ^{
            [NotificationCenter postNotificationName:@"openColors" object:self userInfo:nil];
            
        });
    }
    
    //NSLog(@"MessageID: %i\nToken: %i\nPayload: '%@'",  coapMessage.messageID, coapMessage.token, coapMessage.payload);
    
    [iExchange closeExchange];
    [self cancelTimer];
   
    
    
}
- (void)iCoAPExchange:(ICoAPExchange *)exchange didFailWithError:(NSError *)error {
    //Handle Errors
    if (error.code == IC_UDP_SOCKET_ERROR || error.code == IC_RESPONSE_TIMEOUT) {
        //NSLog(@"Dead End");
    }
    //else NSLog(@"Dead End1");
}


- (void)iCoAPExchange:(ICoAPExchange *)exchange didRetransmitCoAPMessage:(ICoAPMessage *)coapMessage number:(uint)number finalRetransmission:(BOOL)final {
     //NSLog(@"Retrasnmit");
  
}





@end
