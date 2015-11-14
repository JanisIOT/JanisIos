//
//  ViewController.m
//  Restaurant
//
//  Created by SergioDan on 8/30/15.
//  Copyright (c) 2015 SergioDan. All rights reserved.
//

#import "LEDMenu.h"
#import "SessionManager.h"

@interface LEDMenu ()

@end

@implementation LEDMenu{
    NSArray *items;
    NSDictionary *properties;
}
@synthesize menuActive;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    menuActive = NO;
    items=@[@"Janis",@"Contact" ];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openMenu_notif:) name:@"open" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnToWizard:) name:@"openWizard" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnToColors:) name:@"openColors" object:nil];
}
-(void) openMenu_notif:(NSNotification *)notif{
    [self revealLeftMenu];
}

-(void) returnToWizard:(NSNotification *)notif{
    NSIndexPath *initialIndex = [self selectedIndexPath];
    [self tableView:self.tableView didSelectRowAtIndexPath:initialIndex];
}
-(void) returnToColors:(NSNotification *)notif{
    NSIndexPath *initialIndex = [self selectedIndexPath];
    [self tableView:self.tableView didSelectRowAtIndexPath:initialIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(NSIndexPath*) selectedIndexPath{
    return [NSIndexPath indexPathForRow:0 inSection:0];
    // return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}

-(NSString*) segueIdForIndexPath:(NSIndexPath *)indexPath{
    NSString *result= [items objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
            if([[SessionManager sharedInstance] getIP].length>0){
                return @"Janis";
                
            }
            else return @"wizard";
        case 1:
            
            return @"Contact";
            
            break;
        default:
            break;
    }
    
   
    
    return (result)?result:@"n/a";
}

-(Boolean) disableContentViewControllerCachingForIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(Boolean) hasRightMenuForIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(Boolean) allowContentViewControllerCachingForIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(Boolean) disablePanGestureForIndexPath:(NSIndexPath *)indexPath{
    //if (indexPath.row ==0) {
    //     return YES;
    //}
    return NO;
}





-(CGFloat) leftMenuVisibleWidth{
    return 305;
}

-(CGFloat) rightMenuVisibleWidth{
    return 305;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"menu_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];//[tableView dequeueReusableCellWithIdentifier:identifier];
    
    //[MGMeridianUtils setViewBackgroundColor:cell withColor:@"000000"];
    //NSInteger hex = [MGMeridianUtils intFromHexString:[properties objectForKey:@"color_separator_line_menu"]];
    //[MGMeridianUtils setBorderColor:cell position:down color:HEXCOLOR(hex)];
    
    NSString *cellContent = [items objectAtIndex:indexPath.row];
    [cell.textLabel setText:cellContent];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    //int maxItems = [items count]-1;
    //if(indexPath.row == maxItems){
    cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)configureMenuButton:(UIButton *)menuButton {
    //[menuButton setFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    
//    [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"menuicon.png"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"menuicon.png"] forState:UIControlStateHighlighted];
    [menuButton setImage:[UIImage imageNamed:@"menuicon.png"] forState:UIControlStateSelected];
    
}

-(void) slideMenuWillSlideIn:(UINavigationController *)selectedContent{
    menuActive=NO;
    //NSLog(@"slideMenuWillSlideIn");
}
-(void) slideMenuDidSlideIn:(UINavigationController *)selectedContent{
    //NSLog(@"slideMenuDidSlideIn");
    menuActive=NO;
}
-(void) slideMenuWillSlideToSide:(UINavigationController *)selectedContent{
    //NSLog(@"slideMenuWillSlideToSide");
    menuActive=YES;
    //[NotificationCenter postNotificationName:k_notifMenuOpen object:self userInfo:@{k_key_menu_state:@(1)}];
}
-(void) slideMenuDidSlideToSide:(UINavigationController *)selectedContent{
    //NSLog(@"slideMenuDidSlideToSide");
}
-(void) slideMenuWillSlideOut:(UINavigationController *)selectedContent{
    //NSLog(@"slideMenuWillSlideOut");
}
-(void) slideMenuDidSlideOut:(UINavigationController *)selectedContent{
    //NSLog(@"slideMenuDidSlideOut");
}
-(void) slideMenuWillSlideToLeft:(UINavigationController *)selectedContent{
    menuActive=YES;
    //NSLog(@"slideMenuWillSlideToLeft");
    //[NotificationCenter postNotificationName:k_notifMenuOpen object:self userInfo:@{k_key_menu_state:@(1)}];
}
-(void) slideMenuDidSlideToLeft:(UINavigationController *)selectedContent{
    //NSLog(@"slideMenuDidSlideToLeft");
}

// It is used to provide a custom configuration for the content CALayer, useful to change shadow style.
-(void) configureSlideLayer:(CALayer*) layer{
    
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    switch (indexPath.section) {
        case 1:
            //[cell setBackgroundColor:HEXCOLOR(0x0485AE)];
            break;
            
        default:
            break;
    }
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

-(void)disableMenu_notif:(NSNotification*)notification{
   
}


//restricts pan gesture interation to 50px on the left and right of the view.
-(Boolean) shouldRespondToGesture:(UIGestureRecognizer*) gesture forIndexPath:(NSIndexPath*)indexPath {
    if([gesture isKindOfClass:[UIPanGestureRecognizer class]]){
        return YES;
        
        
    }
    else return NO;
}
@end
