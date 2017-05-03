//
//  AppDelegate.h
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "Mixpanel/Mixpanel.h"
#import "DUserStoreObject.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) DUserStoreObject *user;
@property (nonatomic, strong) Mixpanel *mixpanel;

@property (nonatomic, strong) NSUserDefaults *data;
@property (strong, nonatomic) UIWindow *window;


@end

