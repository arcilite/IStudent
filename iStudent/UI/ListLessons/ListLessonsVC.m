//
//  ListLessonsVC.m
//  iStudent
//
//  Created by admin on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListLessonsVC.h"
#import "DetailCell.h"
@implementation ListLessonsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *aboutBarItem=[[UIBarButtonItem alloc] initWithTitle:@"Teachers" style:UIBarButtonItemStylePlain target: self action:@selector(share:)];      
        //settingsBarItem.title=@"Setting";
        self.navigationItem.rightBarButtonItem=aboutBarItem;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DetailCell";
    DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( !cell ){
        cell = [[[DetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
   
    if (indexPath.row==0) {
       // cell.date.text = @"5.06.2012";
       // cell.time.text = @"11.50";
        //cell.name.text = @"K2 220";
        cell.addr.text = @"Math";
    }else{
        //cell.date.text = @"5.06.2012";
        //cell.time.text = @"11.50";
       // cell.name.text = @"K2 220";
        cell.addr.text = @"Английский";    
    }
    
    
    
    return cell;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
