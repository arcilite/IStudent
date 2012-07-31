//
//  Engine.h
//  Bruegal
//
//  Created by StableFlow on 24.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"
#import "GDataCalendar.h"
@interface Engine : NSObject{  
	
     DataSource *datasource;
     GDataServiceGoogleCalendar * googleCalendarService;
     NSMutableArray * calendarData;
     NSMutableArray * events;
     NSMutableArray * tableViewEvents;

}
@property(nonatomic,retain)DataSource *datasource;
@property(nonatomic,retain)GDataServiceGoogleCalendar *googleCalendarService;
@property(nonatomic,retain)NSMutableArray * calendarData;
@property(nonatomic,retain)NSMutableArray * events;
@property(nonatomic,retain)NSMutableArray * tableViewEvents;

+(Engine*)sharedEngine;
-(void)loadEngine;


@end
	