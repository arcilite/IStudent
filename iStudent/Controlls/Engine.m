//
//  Engine.m
//  Bruegal
//
//  Created by StableFlow on 24.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"

#import "Engine.h"
#import "AppDelegate.h"
#include <QuartzCore/QuartzCore.h>
#import "DataSource.h"
static Engine *sharedEngine = nil;

@implementation Engine



#pragma mark Singleton Methods

+ (Engine*)sharedEngine
{
    @synchronized(self) 
    {
        if(sharedEngine == nil)
            sharedEngine = [[super allocWithZone:NULL] init];
    }
    return (Engine*)sharedEngine;
}

+ (id)allocWithZone:(NSZone *)zone 
{
    return [[self sharedEngine] retain];
    
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain 
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX; //denotes an object that cannot be released
}

- (id)autorelease 
{
    return self;
}
- (id)init 
{
    if (self = [super init]) 
    {
        [self loadEngine];
        
    }
    return self;
}

-(void)loadEngine
{   
    NSLog(@"333");
     datasource = [[DataSource alloc]init];    
    
}





- (void)dealloc {
   
    [super dealloc];
}


@end

