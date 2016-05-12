//
//  ViewController.m
//  DocChat
//
//  Created by Meyashi Infosoft on 23/12/15.
//  Copyright © 2015 NTechnosoft. All rights reserved.
//

#import "ViewController.h"
#import <TwitterKit/TwitterKit.h>
#import <linkedin-sdk/LISDK.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "MenuViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.RegisterView.hidden = YES;
    
    LEmail.delegate = self;
    LPassword.delegate = self;
    RFname.delegate = self;
    RLname.delegate = self;
    RDob.delegate = self;
    RCountry.delegate = self;
    REmail.delegate = self;
    RPassword.delegate = self;
    
    profile = [[NSMutableDictionary alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USER"]) {
        [[AppDelegate mainDelegate] setUser:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER"]];
        [self performSegueWithIdentifier:@"Menu" sender:self];
    }
    
    self.LoginView.transform = CGAffineTransformIdentity;
    self.RegisterView.alpha = 0.0;
    self.LoginView.alpha = 1.0;
    self.RegisterView.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
    self.RegisterView.hidden = NO;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ShowRegister:(id)sender{
    self.RegisterView.alpha = 0.0;
    [UIView animateWithDuration:0.9 animations:^{
        self.RegisterView.transform = CGAffineTransformIdentity;
        self.RegisterView.alpha = 1.0;
        self.LoginView.alpha = 0.0;
        self.LoginView.transform = CGAffineTransformMakeTranslation(0, -1*self.view.frame.size.height);
    }];
}

- (IBAction)ShowLogin:(id)sender{
    [self.view endEditing:YES];
    self.LoginView.alpha = 0.0;
    [UIView animateWithDuration:0.9 animations:^{
        self.LoginView.transform = CGAffineTransformIdentity;
        self.RegisterView.alpha = 0.0;
        self.LoginView.alpha = 1.0;
        self.RegisterView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
        [self.view setTransform:CGAffineTransformIdentity];
    }];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    textField.frame.origin.y
    float y = 0.0;
    
    if ([textField isEqual:LEmail]) {
        y = 0.0;
    }else if ([textField isEqual:LPassword]) {
        y = 0.0;
    }else if ([textField isEqual:REmail]) {
        y = 225.0+35.0;
    }else if ([textField isEqual:RPassword]) {
        y = 225.0+35.0;
    }else if ([textField isEqual:RFname]) {
        y = 50.0+35.0;
    }else if ([textField isEqual:RLname]) {
        y = 95.0+35.0;
    }else if ([textField isEqual:RDob]) {
        [self ShowDatePicker];
        return NO;
        //y = 140.0+35.0;
    }else if ([textField isEqual:RCountry]) {
        y = 185.0+35.0;
    }
    
    float DEVICE_HEIGHT = [[UIScreen mainScreen] bounds].size.height;
    float visible = DEVICE_HEIGHT - (213.0 + 100.0);
    
    if (y > visible) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view setTransform:CGAffineTransformMakeTranslation(0, visible-y)];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.view setTransform:CGAffineTransformIdentity];
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setTransform:CGAffineTransformIdentity];
    }];
    [textField resignFirstResponder];
    return YES;
}

- (void)ShowDatePicker{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (Picker == nil) {
        Picker = [[UIDatePicker alloc] init];
        [Picker setDatePickerMode:UIDatePickerModeDate];
    }
    [alertController.view addSubview:Picker];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"%@",Picker.date);
        }];
        action;
    })];
    UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
    popoverController.sourceView = self.view;
    popoverController.sourceRect = self.view.bounds;
    [self presentViewController:alertController  animated:YES completion:nil];
}

- (IBAction)ConnectWithFacebook:(id)sender{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             [self GetFacebookProfile];
         }
     }];
}

- (void)GetFacebookProfile{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me"
                                  parameters:@{@"fields": @"id,first_name,last_name,email,location"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        Profile_Pic_Url = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[result objectForKey:@"id"]];
        [profile setObject:[NSString stringWithFormat:@"%@ %@",[result objectForKey:@"first_name"],[result objectForKey:@"last_name"]] forKey:@"NAME"];
        [profile setObject:[NSString stringWithFormat:@"%@",[result objectForKey:@"email"]] forKey:@"EMAIL"];
        [profile setObject:[NSString stringWithFormat:@"%@",[result objectForKey:@"id"]] forKey:@"ID"];
        [profile setObject:Profile_Pic_Url forKey:@"PIC"];
        
        [[AppDelegate mainDelegate] setUser:profile];
        
        [self performSegueWithIdentifier:@"Menu" sender:self];
    }];
}

- (IBAction)ConnectWithTwitter:(id)sender{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        NSLog(@"%@",session.userName);
        if (error == nil) {
            Profile_Pic_Url = [NSString stringWithFormat:@"https://twitter.com/%@/profile_image?size=original",session.userName];
            [profile setObject:[NSString stringWithFormat:@"%@",session.userName] forKey:@"NAME"];
            [profile setObject:[NSString stringWithFormat:@"%@",session.userID] forKey:@"ID"];
            [profile setObject:Profile_Pic_Url forKey:@"PIC"];
            
            [self GetTwitterProfile];
        }

    }];
}

- (void)GetTwitterProfile{
    if ([[Twitter sharedInstance] session]) {
        TWTRShareEmailViewController* shareEmailViewController = [[TWTRShareEmailViewController alloc] initWithCompletion:^(NSString* email, NSError* error) {
            NSLog(@"Email %@, Error: %@", email, error);
            [profile setObject:[NSString stringWithFormat:@"%@",email] forKey:@"EMAIL"];
            [[AppDelegate mainDelegate] setUser:profile];
            [self performSegueWithIdentifier:@"Menu" sender:self];
        }];
        [self presentViewController:shareEmailViewController animated:YES completion:nil];
    } else {
        // TODO: Handle user not signed in (e.g. attempt to log in or show an alert)
    }
}

- (IBAction)connectWithLinkedIn:(id)sender {
    NSArray *permissions = [NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil];
    [LISDKSessionManager createSessionWithAuth:permissions
                                         state:nil
                        showGoToAppStoreDialog:YES
                                  successBlock:^(NSString *returnState) {
                                      NSLog(@"returned state %@",returnState);
                                      [self GetLinkedinProfile];
                                      
                                  }
                                    errorBlock:^(NSError *error) {
                                        NSLog(@"%s %@","error called! ", [error description]);
                                    }
     ];
}

- (void)GetLinkedinProfile{
    NSString *url = @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,picture-url,email-address,location:(country:(code)))?format=json";//email-address id first-name last-name location:(country:(code))
    if ([LISDKSessionManager hasValidSession]) {
        [[LISDKAPIHelper sharedInstance] getRequest:url
                                            success:^(LISDKAPIResponse *response) {
                                                // do something with response
                                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[response.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                                                NSLog(@"%@",dict);
                                                
                                                Profile_Pic_Url = [dict objectForKey:@"pictureUrl"];
                                                
                                                [profile setObject:[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"first-name"],[dict objectForKey:@"last-name"]] forKey:@"NAME"];
                                                [profile setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"email-address"]] forKey:@"EMAIL"];
                                                [profile setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]] forKey:@"ID"];
                                                [profile setObject:Profile_Pic_Url forKey:@"PIC"];
                                                
                                                [[AppDelegate mainDelegate] setUser:profile];
                                                
                                                [self performSegueWithIdentifier:@"Menu" sender:self];
                                                
                                                
                                            }
                                              error:^(LISDKAPIError *apiError) {
                                                  // do something with error
                                              }];
    }
    
}

- (void)SetUserProfile{

}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     [[NSUserDefaults standardUserDefaults] setObject:[[AppDelegate mainDelegate] user] forKey:@"USER"];
     [[NSUserDefaults standardUserDefaults] synchronize];
 }

@end
