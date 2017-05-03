//
//  DUserStoreObject.h
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "NSString+EmailAddresses.h"

@interface DUserStoreObject : NSObject

@property (nonatomic, strong) NSUserDefaults *data;
@property (nonatomic, strong) NSUbiquitousKeyValueStore *cloud;
@property (nonatomic, assign) BOOL logging;

-(NSString *)userDeviceIdentifyer;
-(NSDictionary *)userOnboardedData;
-(NSString *)userEmail;
-(NSString *)userName;

-(void)setDeviceIdentifyer;
-(void)setOnboardedData;
-(void)setUserName:(NSString *)first last:(NSString *)last;
-(void)setUserEmail:(NSString *)email;

-(void)cloudSyncronize:(NSArray *)keys;
-(NSDate *)cloudSyncronizedDate;
-(NSString *)cloudSyncronizedDevice;

@end
