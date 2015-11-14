//
//  StepTwoVC.m
//  LEDLamp
//
//  Created by Camilo  on 10/12/15.
//  Copyright © 2015 Camilo . All rights reserved.
//
#import "SessionManager.h"
#import "StepTwoVC.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "MGHelpers.h"

@interface StepTwoVC ()

@end

@implementation StepTwoVC{
    NSArray* networks;
        NSArray* a;
    NSString *newIp;
    dispatch_source_t _timerDisco;
    dispatch_source_t _timerNetwork;
    dispatch_queue_t queue;
    int i;
}

@synthesize tv_name,tv_pass;




dispatch_source_t discovery(double interval, dispatch_queue_t queue, dispatch_block_t block)
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
- (void)startTimerDiscovery
{
    double secondsToFire = 0.20f;
    //dispatch_queue_t queue_main = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //[ApplicationDelegate showLoadingIndicator];
    [self.bt_next setTitle:@"Loading Janis.." forState:UIControlStateDisabled];
    [self.bt_next setTitle:@"Loading Janis.." forState:UIControlStateNormal];
    [self.bt_next setTitle:@"Loading Janis.." forState:UIControlStateSelected];
    [self.bt_next setTitle:@"Loading Janis.." forState:UIControlStateHighlighted];
    _timerDisco = discovery(secondsToFire, queue, ^{
        newIp =[@"" stringByAppendingFormat:@"%@.%@.%@.%d",[a objectAtIndex:0],[a objectAtIndex:1], [a objectAtIndex:2],i];
        i++;
        NSLog(@"ping on ip %@", newIp);
        [self disco:newIp];
        if(i>255){
            //[self cancelTimerDisco];
            i=0;
            
        }
    });
}

- (void)startTimerNetwork
{
    double secondsToFire = 0.30f;
    //dispatch_queue_t queue_main = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timerNetwork = discovery(secondsToFire, queue, ^{
       
        NSString *ssid=[self getCurrentSSID];
        a = [[self getIPAddress] componentsSeparatedByString: @"." ];
        if(ssid!=nil&& [ssid isEqualToString:self.tv_name.text]&&a.count==4){
            //[self.im_janis setBackgroundColor:[UIColor greenColor]];
             //newIp =[@"" stringByAppendingFormat:@"%@.%@.%@.%d",[a objectAtIndex:0],[a objectAtIndex:1], [a objectAtIndex:2],i];
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
    i=0;
    queue = dispatch_queue_create("janis_queue", NULL);
    NSString *ssid=[[SessionManager sharedInstance] ssid];
    if(ssid.length>0&&![ssid isEqualToString:@"JANIS001"]){
         [tv_name setText:ssid];
        [self.tv_net_name setText:ssid];
        
    }
    
    
    
    [self.bt_next setEnabled:NO];
    //networks =[self networksSSIDs];
    
    
    

}

-(void)viewDidAppear:(BOOL)animated{
     [self startTimerNetwork];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup:(NSString*)payload{
    ICoAPMessage *cO = [[ICoAPMessage alloc] initAsRequestConfirmable:YES requestMethod:IC_GET sendToken:YES payload:payload];
    [cO addOption:IC_URI_PATH withValue:@"setup"];
    if (!iExchange) {
        iExchange = [[ICoAPExchange alloc] initAndSendRequestWithCoAPMessage:cO toHost:@"192.168.4.1" port:5683 delegate:self];
    }
    else {
        [iExchange sendRequestWithCoAPMessage:cO toHost:@"192.168.4.1" port:5683];
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


- (IBAction)ssid:(id)sender {
    
    [sender resignFirstResponder];
    [self.tv_net_name setText:tv_name.text];
    [tv_pass becomeFirstResponder];
    
    
    
    
    
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

- (IBAction)pass:(id)sender {
    [sender resignFirstResponder];
    
    NSString *pass = ((UILabel*)sender).text;
     NSString *name = tv_name.text;
    if(pass.length>0 && name.length>0){
        NSString *payload=[@"" stringByAppendingFormat:@"%@=%@=",name, pass ];
        [self setup:payload];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Porfavor ingresa tu clave de red y contraseña correctamente"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok",nil];
        [alert show];
        
    }
    
    
    
    
}

- (IBAction)control:(id)sender {
    
    
    
    [self performSegueWithIdentifier:@"control" sender:nil];
    //[ApplicationDelegate showLoadingIndicator];
   // [self startTimer];
    
       
}

- (void)iCoAPExchange:(ICoAPExchange *)exchange didReceiveCoAPMessage:(ICoAPMessage *)coapMessage {
    
    
    
    //NSLog(@"MessageID: %i\nToken: %i\nPayload: '%@'",  coapMessage.messageID, coapMessage.token, coapMessage.payload);
    
    
    if([coapMessage.payload isEqualToString:@"1"]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.bt_next setTitle:@"Control Janis" forState:UIControlStateDisabled];
            [self.bt_next setTitle:@"Control Janis" forState:UIControlStateNormal];
            [self.bt_next setTitle:@"Control Janis" forState:UIControlStateSelected];
            [self.bt_next setTitle:@"Control Janis" forState:UIControlStateHighlighted];
            [self.im_janis setBackgroundColor:[UIColor greenColor]];
            [self.bt_next setEnabled:YES];
        });
        
        
        [[SessionManager sharedInstance] setIP:newIp];
        [[SessionManager sharedInstance] setIp:newIp];
        [self cancelTimerDisco];
                
        //[ApplicationDelegate hideLoadingIndicator];
    }
    
    else if(i>=255){
        //[self cancelTimerDisco];
        [ApplicationDelegate hideLoadingIndicator];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Intenta de nuevo"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok",nil];
        [alert show];

        i=0;
        
    }
    else if([coapMessage.payload isEqualToString:@"2"]){
        
    }
        
    
    
    
    
    
}
- (void)iCoAPExchange:(ICoAPExchange *)exchange didFailWithError:(NSError *)error {
    //Handle Errors
    if (error.code == IC_UDP_SOCKET_ERROR || error.code == IC_RESPONSE_TIMEOUT) {
        //NSLog(@"Dead End");
       
    }
    if(i>=255){
        [self cancelTimerDisco];
        [ApplicationDelegate hideLoadingIndicator];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Intenta de nuevo"
//                                                        message:nil
//                                                       delegate:nil
//                                              cancelButtonTitle:nil
//                                              otherButtonTitles:@"Ok",nil];
//        [alert show];

        i=0;
        
    }
}


- (void)iCoAPExchange:(ICoAPExchange *)exchange didRetransmitCoAPMessage:(ICoAPMessage *)coapMessage number:(uint)number finalRetransmission:(BOOL)final {
    
}
@end
