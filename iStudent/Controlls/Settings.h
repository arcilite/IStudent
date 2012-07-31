//
//  Settings.h
//  Bruegal
//
//  Created by StableFlow on 24.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//#import"SyncSettings.h"
//#import"JSONSettings.h"

#define APPLICATION_DOCUMENTS_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APPLICATION_CACHE_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define WEB_CACHE_PATH [APPLICATION_CACHE_DIRECTORY stringByAppendingPathComponent:@"WebCache"]

#define APPLICATION_FRAME [[UIScreen mainScreen] bounds]

#define SETTINGS_ROOT_PLIST_PATH [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"]] pathForResource:@"Root" ofType:@"plist"]
#define en [Engine sharedEngine]
