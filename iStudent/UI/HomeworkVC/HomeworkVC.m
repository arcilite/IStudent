//
//  HomeworkVC.m
//  iStudent
//
//  Created by admin on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeworkVC.h"
#import "DetailCell.h"
#import "HomeworkCell.h"
@implementation HomeworkVC
@synthesize homevorkTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *editBarItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];      
        //settingsBarItem.title=@"Setting";
        self.navigationItem.leftBarButtonItem=editBarItem;
        UIBarButtonItem *aboutBarItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];      
        //settingsBarItem.title=@"Setting";
        self.navigationItem.rightBarButtonItem=aboutBarItem;
    }
    return self;
}
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
    HomeworkCell *cell = (HomeworkCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( !cell ){
        cell = [[[HomeworkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.date.text = @"5.06.2012";
    cell.time.text = @"11.50";
    cell.name.text = @"Английский ";
    cell.addr.text = @"Выучить текст England  сделать упр 12";
    
    
    
    return cell;
}

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
    [self setHomevorkTableView:nil];
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
    [homevorkTableView release];
    [super dealloc];
}
@end
