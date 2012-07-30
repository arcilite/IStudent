//
//  CalendarVC.m
//  StudentShedule
//
//  Created by Arcilite on 04.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarVC.h"
#import "DetailCell.h"

#define KEY_CALENDAR @"calendar"
#define KEY_EVENTS @"events"
#define KEY_TICKET @"ticket"
#define KEY_EDITABLE @"editable"
@implementation CalendarVC
@synthesize calendarView; 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        username = @"tork.the.knight@gmail.com";
        password = @"q700649";
        calendarData = [[NSMutableArray alloc]init];
        events = [[NSMutableArray alloc]init];
        tableViewEvents = [[NSMutableArray alloc]init];
        
        googleCalendarService = [[GDataServiceGoogleCalendar alloc] init];
        [googleCalendarService setUserAgent:@"DanBourque-GTUGDemo-1.0"];
        [googleCalendarService setServiceShouldFollowNextLinks:NO];
        
        [googleCalendarService setUserCredentialsWithUsername:username
                                                     password:password]; 
        
        calendarView = nil;
        
        [self loadUI];
        
        [self refresh];  
    }
    return self;
}

- (void) loadUI {
   
	int statusBarHeight = 20;
	CGRect applicationFrame = (CGRect)[[UIScreen mainScreen] applicationFrame];
	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight, applicationFrame.size.width, applicationFrame.size.height)] autorelease];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = [UIColor grayColor];
    
    contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 280, self.view.frame.size.width, self.view.frame.size.height - 260 - 89) style:UITableViewStyleGrouped];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentTableView];
    [self toggleCalendar];
    
    self.title = NSLocalizedString(@"Calendar", @"");
}

- (void) toggleCalendar {
    
    if (!calendarView) {
        calendarView = 	[[TKCalendarMonthView alloc] init];
        [self.view addSubview:calendarView];
    }
    
    calendarView.delegate = self;
    calendarView.dataSource = self;
    
	calendarView.frame = CGRectMake(0, 0, calendarView.frame.size.width, calendarView.frame.size.height);
    [calendarView reload];
}

#pragma mark -
#pragma mark saving events methods

- (void) saveEvent {
    
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB];
    
    GDataEntryCalendarEvent *event = [tableViewEvents objectAtIndex:selectedEvent];
    GDataWhen *when = [[event objectsForExtensionClass:[GDataWhen class]] objectAtIndex:0];
    if( when ){
        NSDate *date = [[when startTime] date];
        
        myEvent.startDate = date;
        myEvent.endDate   = date;
    }
    
    myEvent.title = [[event title] stringValue];
	myEvent.allDay = YES;
    
    [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
    
    NSError *err;
    
    [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err]; 
    
	if (err == noErr) {
		UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:@"Event Was Created"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
    [eventDB release];
}

#pragma mark - 
#pragma mark UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:selectedEvent inSection:0];
    [contentTableView deselectRowAtIndexPath:indexPath animated:YES]; 
    
    if (buttonIndex == 1) {
        
        [self saveEvent];
    }
}

#pragma mark -
#pragma mark google calendar methods

- (void)refresh{
    
    [calendarData removeAllObjects];
    
    [googleCalendarService fetchCalendarFeedForUsername:username
                                               delegate:self
                                      didFinishSelector:@selector( calendarsTicket:finishedWithFeed:error: )];
}

- (void)calendarsTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedCalendar *)feed error:(NSError *)error{
    if( !error ){
        int count = [[feed entries] count];
        for( int i=0; i<count; i++ ){
            GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:i];
            
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [calendarData addObject:dictionary];
            
            [dictionary setObject:calendar forKey:KEY_CALENDAR];
            [dictionary setObject:[[NSMutableArray alloc] init] forKey:KEY_EVENTS];
            
            NSURL *feedURL = [[calendar alternateLink] URL];
            if( feedURL ){
                GDataQueryCalendar* query = [GDataQueryCalendar calendarQueryWithFeedURL:feedURL];
                
                NSDate *minDate = [NSDate dateWithTimeIntervalSinceNow:-(60*60*24)];  // From right now...
                NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*90];  // ...to 90 days from now.
                
                [query setMinimumStartTime:[GDataDateTime dateTimeWithDate:minDate timeZone:[NSTimeZone systemTimeZone]]];
                [query setMaximumStartTime:[GDataDateTime dateTimeWithDate:maxDate timeZone:[NSTimeZone systemTimeZone]]];
                [query setOrderBy:@"starttime"];  // http://code.google.com/apis/calendar/docs/2.0/reference.html#Parameters
                [query setIsAscendingOrder:YES];
                [query setShouldExpandRecurrentEvents:YES];
                
                GDataServiceTicket *ticket = [googleCalendarService fetchFeedWithQuery:query
                                                                              delegate:self
                                                                     didFinishSelector:@selector( eventsTicket:finishedWithEntries:error: )];
                [dictionary setObject:ticket forKey:KEY_TICKET];
            }
            [dictionary release];
        }
    }else
        [self handleError:error];
}

- (void)handleError:(NSError *)error{
    NSString *title, *msg;
    if( [error code]==kGDataBadAuthentication ){
        title = @"Authentication Failed";
        msg = @"Invalid username/password\n\nPlease go to the iPhone's settings to change your Google account credentials.";
    }else{
        title = @"Unknown Error";
        msg = [error localizedDescription];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)eventsTicket:(GDataServiceTicket *)ticket finishedWithEntries:(GDataFeedCalendarEvent *)feed error:(NSError *)error{
    if( !error ){
        NSMutableDictionary *dictionary;
        for( int section=0; section<[calendarData count]; section++ ){
            NSMutableDictionary *nextDictionary = [calendarData objectAtIndex:section];
            GDataServiceTicket *nextTicket = [nextDictionary objectForKey:KEY_TICKET];
            if( nextTicket==ticket ){		// We've found the calendar these events are meant for...
                dictionary = nextDictionary;
                break;
            }
        }
        
        if( !dictionary )
            return;
        
        int count = [[feed entries] count];
        
        for( int i=0; i<count; i++ ) {
            [events addObject:[[feed entries] objectAtIndex:i]];
        }
        
        NSURL *nextURL = [[feed nextLink] URL];
        if( nextURL ){
            GDataServiceTicket *newTicket = [googleCalendarService fetchFeedWithURL:nextURL
                                                                           delegate:self
                                                                  didFinishSelector:@selector( eventsTicket:finishedWithEntries:error: )];
            [dictionary setObject:newTicket forKey:KEY_TICKET];
        }
    }else
        [self handleError:error];
    [self toggleCalendar];
}

#pragma mark -
#pragma mark table view & data source methods

- (NSMutableArray *)eventsForIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictionary = [self dictionaryForIndexPath:indexPath];
    if( dictionary )
        return [dictionary valueForKey:KEY_EVENTS];
    return nil;
}

- (NSDictionary *)dictionaryForIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section<[calendarData count] )
        return [calendarData objectAtIndex:indexPath.section];
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [tableViewEvents count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DetailCell";
    DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( !cell ){
        cell = [[[DetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.date.text = cell.time.text = cell.name.text = cell.addr.text = @"";
    
    if( indexPath.row<[tableViewEvents count] ){
        GDataEntryCalendarEvent *event = [tableViewEvents objectAtIndex:indexPath.row];
        GDataWhen *when = [[event objectsForExtensionClass:[GDataWhen class]] objectAtIndex:0];
        if( when ){
            NSDate *date = [[when startTime] date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"dd-MM-yy"];
            cell.date.text = [dateFormatter stringFromDate:date];
            [dateFormatter setDateFormat:@"HH:mm"];
            cell.time.text = [dateFormatter stringFromDate:date];
            
            [dateFormatter release];
        }
        cell.name.text = [[event title] stringValue];
        GDataWhere *addr = [[event locations] objectAtIndex:0];
        if( addr )
            cell.addr.text = [addr stringValue];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedEvent = indexPath.row;
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"You want store event in your device?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
    [alertView release];
}

#pragma mark -
#pragma mark TKCalendarMonthViewDelegate methods

- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d {
    [tableViewEvents removeAllObjects];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd"];
    
    for (id obj in events) {
        
        GDataWhen *when = [[obj objectsForExtensionClass:[GDataWhen class]] objectAtIndex:0];
        if( when ){
            
            if ([[dateFormatter stringFromDate:d] isEqualToString:[dateFormatter stringFromDate:[[when startTime] date]]]) {
                
                [tableViewEvents addObject:obj];
            }
        }
    }
    
    [dateFormatter release];
    [contentTableView reloadData];
	////NSLog(@"calendarMonthView didSelectDate %@", [d description]);
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d {
    [tableViewEvents removeAllObjects];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd"];
    
    for (id obj in events) {
        
        GDataWhen *when = [[obj objectsForExtensionClass:[GDataWhen class]] objectAtIndex:0];
        if( when ){
            
            if ([[dateFormatter stringFromDate:d] isEqualToString:[dateFormatter stringFromDate:[[when startTime] date]]]) {
                
                [tableViewEvents addObject:obj];
            }
        }
    }
    
    [dateFormatter release];
    [contentTableView reloadData];
	////NSLog(@"calendarMonthView monthDidChange");	
}

#pragma mark -
#pragma mark TKCalendarMonthViewDataSource methods

- (NSArray*)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate {	
	////NSLog(@"calendarMonthView marksFromDate toDate");	
	////NSLog(@"Make sure to update 'data' variable to pull from CoreData, website, User Defaults, or some other source.");
    
    
    NSArray *data;
    NSMutableArray * arr = [[[NSMutableArray alloc]init]autorelease];
	for (id obj in events) {
        
        GDataWhen *when = [[obj objectsForExtensionClass:[GDataWhen class]] objectAtIndex:0];
        if(when){
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            [arr addObject:[NSString stringWithFormat:@"%@ 00:00:00 +0000", [dateFormatter stringFromDate:[[when startTime] date]]]];
            [dateFormatter release];
        }
    }
    data = [NSArray arrayWithArray:arr];
    
	NSMutableArray *marks = [NSMutableArray array];
	
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
	NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | 
                                              NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) 
                                    fromDate:startDate];
	NSDate *d = [cal dateFromComponents:comp];
    
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setDay:1];	
	
	while (YES) {
        // //NSLog(@"while");
		if ([d compare:lastDate] == NSOrderedDescending) {
			break;
		}
		if ([data containsObject:[d description]]) {
			[marks addObject:[NSNumber numberWithBool:YES]];
		} else {
			[marks addObject:[NSNumber numberWithBool:NO]];
		}
		d = [cal dateByAddingComponents:offsetComponents toDate:d options:0];
	}
	
	[offsetComponents release];
    
	return [NSArray arrayWithArray:marks];
}

#pragma mark -
#pragma mark Memory Management


- (void)dealloc {
	[calendarView release];
    [googleCalendarService release];
    [calendarData release];
    [contentTableView release];
    [events release];
    [tableViewEvents release];
    
    [super dealloc];
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
