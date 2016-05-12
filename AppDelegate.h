//
//  AppDelegate.h
//  DocChat
//
//  Created by Meyashi Infosoft on 23/12/15.
//  Copyright © 2015 NTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSDictionary *user;

+ (AppDelegate *)mainDelegate;

@end

