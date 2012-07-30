//
//  DetailCell.h
//  GoogleCalendar
//
//  Created by Dan Bourque on 4/30/09.
//  Copyright Dan Bourque 2009. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell{
  UILabel *date, *time, *name, *addr;
}

@property (readonly, retain) UILabel *date, *time, *name, *addr;

@end