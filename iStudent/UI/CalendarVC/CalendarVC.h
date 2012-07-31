//
//  CalendarVC.h
//  StudentShedule
//
//  Created by Arcilite on 04.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "TKCalendarMonthView.h"
#import "GDataCalendar.h"
#import "Engine.h"

@interface CalendarVC : UIViewController <TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource,
UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
	TKCalendarMonthView *calendarView;	
    
    //GDataServiceGoogleCalendar * googleCalendarService;
    
    NSString * username;
    NSString * password;
    
   // NSMutableArray * calendarData;
   // NSMutableArray * events;
   // NSMutableArray * tableViewEvents;
    UITableView * contentTableView;
    int selectedEvent;
	
	UIButton *backBtn;
    UILabel *backBtnLabel;
    
}

@property (nonatomic, retain) TKCalendarMonthView *calendarView;

- (void) loadUI;
- (void) refresh;
- (void)handleError:(NSError *)error;
- (NSMutableArray *)eventsForIndexPath:(NSIndexPath *)indexPath;
- (NSDictionary *)dictionaryForIndexPath:(NSIndexPath *)indexPath;
- (void) saveEvent;
- (void) toggleCalendar;


@end