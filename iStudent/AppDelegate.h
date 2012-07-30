//
//  AppDelegate.h
//  iStudent
//
//  Created by admin on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController * navController1;
    UINavigationController * navController2;
    UINavigationController * navController3;
    UINavigationController * navController4;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@end
