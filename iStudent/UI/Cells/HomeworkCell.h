//
//  HomeworkCell.h
//  iStudent
//
//  Created by Apple on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkCell : UITableViewCell{
    UILabel *date, *time, *name, *addr;
}

@property (readonly, retain) UILabel *date, *time, *name, *addr;

@end
