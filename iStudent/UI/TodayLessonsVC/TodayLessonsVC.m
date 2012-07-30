//
//  TodayLessonsVC.m
//  iStudent
//
//  Created by admin on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TodayLessonsVC.h"
#import "DetailCell.h"
#import "Settings.h"
#import "SettingsViewController.h"
@implementation TodayLessonsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        todayTableView.delegate=self;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        navBar.topItem.title = @"Today";
        UIBarButtonItem *settingsBarItem=[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target: self action:@selector(setingsAction:)];      
          self.navigationItem.leftBarButtonItem=settingsBarItem;
        UIBarButtonItem *aboutBarItem=[[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target: self action:@selector(aboutAction:)];      
       
        self.navigationItem.rightBarButtonItem=aboutBarItem;

    }
    return self;
}
-(void)setingsAction:(id)button{
    SettingsViewController * setingsViewController=[[SettingsViewController alloc]init];
    [self.navigationController pushViewController:setingsViewController animated:YES];
    [setingsViewController release];
}

-(void)aboutAction:(id)button{
    
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DetailCell";
    DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( !cell ){
        cell = [[[DetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.date.text = @"5.06.2012";
    cell.time.text = @"11.50";
    cell.name.text = @"K2 220";
    cell.addr.text = @"Английский";
    
        
    
    return cell;
}

// Section header & footer information. Views are preferred over title should you decide to provide both





- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [todayTableView release];
    todayTableView = nil;
    [navBar release];
    navBar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [todayTableView release];
    [navBar release];
    [super dealloc];
}
@end
