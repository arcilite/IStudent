//
//  DetailCell.m
//  GoogleCalendar
//
//  Created by Dan Bourque on 4/30/09.
//  Copyright Dan Bourque 2009. All rights reserved.
//
#import "DetailCell.h"

@implementation DetailCell

@synthesize date, time, name, addr;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if( self=[super initWithStyle:style reuseIdentifier:reuseIdentifier] ){
      
        // Initialize the labels, their fonts, colors, alignment, and background color.
        date = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, 20)];
        date.font = [UIFont boldSystemFontOfSize:12];
        date.textColor = [UIColor darkGrayColor];
        date.textAlignment = UITextAlignmentLeft;
        date.backgroundColor = [UIColor clearColor];
    
        time = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(date.frame), self.frame.size.width - 20, 20)];
        time.font = [UIFont boldSystemFontOfSize:12];
        time.textColor = [UIColor darkGrayColor];
        time.textAlignment = UITextAlignmentLeft;
        time.backgroundColor = [UIColor clearColor];
    
        name = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(time.frame), self.frame.size.width - 30, 20)];
        name.font = [UIFont boldSystemFontOfSize:14];
        name.backgroundColor = [UIColor clearColor];
    
        addr = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, self.frame.size.width-20 , 40)];
        addr.font = [UIFont boldSystemFontOfSize:20];
        addr.textColor = [UIColor darkGrayColor];
        addr.backgroundColor = [UIColor clearColor];
      
        [self.contentView addSubview:date];
        [self.contentView addSubview:time];
        [self.contentView addSubview:name];
        [self.contentView addSubview:addr];
    }
    return self;
}

- (void)dealloc {

    [date release];
    [time release];
    [name release];
    [addr release];
    
    [super dealloc];
}

@end