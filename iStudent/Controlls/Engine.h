//
//  Engine.h
//  Bruegal
//
//  Created by StableFlow on 24.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"

@interface Engine : NSObject{  
	
     DataSource *datasource;
}



+(Engine*)sharedEngine;
-(void)loadEngine;


@end
	