//
//  DDownloadObject.h
//  DoofApp
//
//  Created by Joe Barbour on 06/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DVideoObjectDelegate;
@interface DDownloadObject : NSObject

@property (nonatomic, strong) id <DVideoObjectDelegate> delegate;
@property (nonatomic, strong) NSUserDefaults *data;
@property (nonatomic, assign) NSURLSession *session;
@property (nonatomic, assign) NSString *filename;

-(void)videoDownloadFromStream:(NSURL *)stream key:(NSString *)key;
-(void)videoMergeWithPromo;

@end

@protocol DVideoObjectDelegate <NSObject>

@optional



@end
