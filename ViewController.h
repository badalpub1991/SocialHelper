//
//  ViewController.h
//  DocChat
//
//  Created by Meyashi Infosoft on 23/12/15.
//  Copyright © 2015 NTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *LEmail, *LPassword;
    IBOutlet UITextField *RFname, *RLname, *RDob, *RCountry, *REmail, *RPassword;
    UIDatePicker *Picker;
    NSString *Profile_Pic_Url;
    NSMutableDictionary *profile;
}

@property(nonatomic, strong)IBOutlet UIView *LoginView, *RegisterView;

@end

