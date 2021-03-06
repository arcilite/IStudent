//
//  SettingsViewController.m
//  iStudent
//
//  Created by Apple on 30.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "SFHFKeychainUtils.h"
#import "Engine.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [passwordTextField release];
    passwordTextField = nil;
    [loginTextField release];
    loginTextField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)saveAction:(id)sender {
    if (passwordTextField.text.length>0&&loginTextField.text.length>0) {
        NSString *loginValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"login"];
    if(loginValue){
        
    [SFHFKeychainUtils deleteItemForUsername: loginValue andServiceName: @"myAdressBook" error: nil];
    }   
    
    NSString *valueToSave = loginTextField.text;
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:valueToSave];
    [[NSUserDefaults standardUserDefaults]
     setObject:valueToSave forKey:@"login"];
       
    [SFHFKeychainUtils  storeUsername:valueToSave 
						  andPassword: passwordTextField.text
					   forServiceName: @"myAdressBook" 
					   updateExisting: NO 
								error: nil];

    [[NSUserDefaults standardUserDefaults] synchronize] ;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Succesfull" message:@"Your Pasword succesfully saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
    [en.googleCalendarService setUserCredentialsWithUsername:valueToSave
                                                        password:passwordTextField.text];
        [self.navigationController popViewControllerAnimated:YES];    
    }else {
        [[NSUserDefaults standardUserDefaults] synchronize] ;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input right data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [passwordTextField release];
    [loginTextField release];
    [super dealloc];
}
@end
