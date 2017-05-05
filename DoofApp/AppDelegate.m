//
//  AppDelegate.m
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import "AppDelegate.h"
#import "DContstants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(instancetype)init {
    self = [super init];
    if (self) {
        self.data =  [[NSUserDefaults alloc] initWithSuiteName:APP_SAVE_DIRECTORY];
        
        self.user = [[DUserStoreObject alloc] init];
        self.user.logging = true;
        
    
    }
    return self;
    
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class]]];
    
    if (!APP_DEBUG_MODE) [Mixpanel sharedInstanceWithToken:APP_MIXPANEL_TOKEN];
    
    [self.user cloudSyncronize:nil];
    
    if (self.user.userDeviceIdentifyer == nil) {
        [self.user setDeviceIdentifyer];
        
        [[Mixpanel sharedInstance] identify:self.user.userDeviceIdentifyer];
        [[Mixpanel sharedInstance] track:@"App Installed"];
        [[Mixpanel sharedInstance].people set:@{@"Device":[UIDevice currentDevice].name}];
        
    }
    else {
        [[Mixpanel sharedInstance] track:@"App Opened"];

    }
    
    return true;
    
}

-(void)applicationAuthorizeRemoteNotifications:(void (^)(NSError *error, BOOL granted))completion {
    if (APP_DEVICE >= 10){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound|UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
            completion(error, granted);
            
        }];
        
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        completion(nil, true);
        
    }
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[Mixpanel sharedInstance].people addPushDeviceToken:deviceToken];
    [[Mixpanel sharedInstance] track:@"Push Notifications Registered"];
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

-(void)applicationWillResignActive:(UIApplication *)application {

}

-(void)applicationDidEnterBackground:(UIApplication *)application {

}


-(void)applicationWillEnterForeground:(UIApplication *)application {

}


-(void)applicationDidBecomeActive:(UIApplication *)application {

}


-(void)applicationWillTerminate:(UIApplication *)application {

}


@end
