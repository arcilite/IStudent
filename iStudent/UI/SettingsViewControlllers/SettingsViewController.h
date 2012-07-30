//
//  SettingsViewController.h
//  iStudent
//
//  Created by Apple on 30.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
@interface SettingsViewController : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *loginTextField;
    IBOutlet UITextField *passwordTextField;
   
}
- (IBAction)saveAction:(id)sender;

@end
