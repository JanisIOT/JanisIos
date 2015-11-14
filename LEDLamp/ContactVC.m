//
//  ContactVC.m
//  LEDLamp
//
//  Created by Camilo  on 10/15/15.
//  Copyright © 2015 Camilo . All rights reserved.
//

#import "ContactVC.h"
#import "SessionManager.h"
#import "MGHelpers.h"

@interface ContactVC ()

@end

@implementation ContactVC


-(void) setupNavBar {
    //[self.navigationItem setHidesBackButton:NO];
    UIButton *btn_back= [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 46.0, 46.0)];
    
    [btn_back setImage:[UIImage imageNamed:@"Icon.png"]     forState:UIControlStateNormal];
    [btn_back setImage:[UIImage imageNamed:@"Icon.png"]  forState:UIControlStateSelected];
    [btn_back setImage:[UIImage imageNamed:@"Icon.png"]  forState:UIControlStateHighlighted];
    
    UIBarButtonItem *item_back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuicon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButton:)];
    [self.navigationItem setHidesBackButton:YES];
    
    [self.navigationItem setLeftBarButtonItems:@[item_back] animated:NO];
    [self.navigationItem setLeftItemsSupplementBackButton:YES];
}
-(void) backButton:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"open" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = HEXCOLOR(0x00A9FF);
        self.navigationController.navigationBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = HEXCOLOR(0x00A9FF);
    }

    [self setupNavBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reset{
    
    
    if([[SessionManager sharedInstance] getIP].length>0){
        ICoAPMessage *cO = [[ICoAPMessage alloc] initAsRequestConfirmable:YES requestMethod:IC_GET sendToken:YES payload:nil];
        [cO addOption:IC_URI_PATH withValue:@"reset"];
        if (!iExchange) {
            iExchange = [[ICoAPExchange alloc] initAndSendRequestWithCoAPMessage:cO toHost:[[SessionManager sharedInstance] ip] port:5683 delegate:self];
        }
        else {
            [iExchange sendRequestWithCoAPMessage:cO toHost:[[SessionManager sharedInstance] ip] port:5683];
        }
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
