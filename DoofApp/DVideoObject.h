//
//  DVideoObject.h
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVideoObject : NSObject

@property (nonatomic, strong) NSUserDefaults *data;
@property (nonatomic, strong) NSURLSession *session;

-(void)queryVideosWithType:(NSString *)type completion:(void (^)(NSError *error, NSArray *videos))completion;

@end
