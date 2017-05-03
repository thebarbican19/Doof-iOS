//
//  DUserStoreObject.m
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import "DUserStoreObject.h"
#import "DContstants.h"

@implementation DUserStoreObject

-(instancetype)init {
    self = [super init];
    if (self) {
        self.data =  [[NSUserDefaults alloc] initWithSuiteName:APP_SAVE_DIRECTORY];
        self.cloud = [NSUbiquitousKeyValueStore defaultStore];
        
    }
    return self;
    
}

-(NSString *)userDeviceIdentifyer {
    return [self.data objectForKey:@"user_deviceid"];
    
}

-(NSDictionary *)userOnboardedData {
    return [self.data objectForKey:@"user_onboarding"];

}

-(NSString *)userName {
    if ([self.data objectForKey:@"user_firstname"] == nil && [self.data objectForKey:@"user_lastname"] == nil) return nil;
    else return [NSString stringWithFormat:@"%@ %@" ,[self.data objectForKey:@"user_firstname"] ,
                                                     [self.data objectForKey:@"user_lastname"]];


}

-(NSString *)userEmail {
    return [self.data objectForKey:@"user_email"];
    
}

-(void)setDeviceIdentifyer {
    if ([self.data objectForKey:@"user_deviceid"] == nil) {
        CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
        CFRelease(newUniqueId);
        
        [self.data setObject:uuidString forKey:@"user_deviceid"];
        [self.data synchronize];
        
        [self cloudSyncronize:@[@"user_deviceid"]];

    }
    
}

-(void)setOnboardedData {
    [self.data setObject:@{@"onboarded":[NSNumber numberWithBool:true],
                           @"timestamp":[NSDate date],
                           @"version":APP_VERSION} forKey:@"user_onboarding"];
    [self.data synchronize];
    
    [self cloudSyncronize:@[@"user_onboarding"]];

}

-(void)setUserName:(NSString *)first last:(NSString *)last {
    [self.data setObject:first.capitalizedString forKey:@"user_firstname"];
    [self.data setObject:last.capitalizedString forKey:@"user_lastname"];
    [self.data synchronize];

    [self cloudSyncronize:@[@"user_firstname" ,@"user_lastname"]];

}

-(void)setUserEmail:(NSString *)email {
    [self.data setObject:[email stringByCorrectingEmailTypos] forKey:@"user_email"];
    [self.data synchronize];
    
    [self cloudSyncronize:@[@"user_email"]];
    
}

-(void)cloudSyncronize:(NSArray *)keys {
    if (keys != nil) {
        for (NSString *key in keys) {
            [self.cloud setObject:[self.data objectForKey:key] forKey:key];
            if (self.logging) NSLog(@"Saving %@ to Cloud" ,key);

        }
        
        [self.cloud setObject:[NSDate date] forKey:@"sync_date"];
        [self.cloud setObject:[NSNumber numberWithBool:true] forKey:@"sync_sucsess"];
        [self.cloud setObject:[UIDevice currentDevice].name forKey:@"sync_device"];
        [self.cloud synchronize];
        
    }
    else {
        NSLog(@"Syncronizing...");
        for (NSString *key in [self.cloud dictionaryRepresentation])  {
            [self.data setObject:[[self.data dictionaryRepresentation] objectForKey:key] forKey:key];
            if (self.logging) NSLog(@"Saving %@ from Cloud" ,key);

        }
        
        [self.data setObject:[NSDate date] forKey:@"sync_date"];
        [self.data setObject:[NSNumber numberWithBool:true] forKey:@"sync_sucsess"];
        [self.data setObject:[UIDevice currentDevice].name forKey:@"sync_device"];
        [self.data synchronize];
        
    }
    
}

-(NSDate *)cloudSyncronizedDate {
    return [self.cloud objectForKey:@"sync_date"];

}

-(NSString *)cloudSyncronizedDevice {
    return [self.cloud objectForKey:@"sync_device"];

}

@end
