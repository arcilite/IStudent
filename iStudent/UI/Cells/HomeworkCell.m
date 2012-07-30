//
//  HomeworkCell.m
//  iStudent
//
//  Created by Apple on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeworkCell.h"

@implementation HomeworkCell
@synthesize date, time, name, addr;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
        
        name = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(time.frame)+10, self.frame.size.width - 30, 20)];
        name.font = [UIFont boldSystemFontOfSize:10];
        name.backgroundColor = [UIColor clearColor];
        
        addr = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, self.frame.size.width-90 , 40)];
        addr.font = [UIFont boldSystemFontOfSize:14];
        addr.lineBreakMode=UILineBreakModeCharacterWrap;
        addr.numberOfLines=3;//addr.textColor = [UIColor darkGrayColor];
        addr.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:date];
        [self.contentView addSubview:time];
        [self.contentView addSubview:name];
        [self.contentView addSubview:addr];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
