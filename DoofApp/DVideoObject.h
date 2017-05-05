//
//  DVideoObject.h
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DVideoObjectDelegate;
@interface DVideoObject : NSObject

@property (nonatomic, strong) id <DVideoObjectDelegate> delegate;
@property (nonatomic, strong) NSUserDefaults *data;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, assign) NSString *nextpage;
@property (nonatomic, assign) int results;

-(void)queryVideosWithType:(NSString *)type force:(BOOL)force;

-(BOOL)videoExists:(NSString *)identfyer;
-(NSMutableArray *)videosStored;
-(NSMutableArray *)videosSaved;
-(NSMutableArray *)videosWithType:(NSString *)type;
-(void)videoCacheDestroy;
-(BOOL)videoCacheExpired;

@end

@protocol DVideoObjectDelegate <NSObject>

@optional

-(void)queryingVideos;
-(void)queryingCompleteWithVideos;
-(void)queryingReturnedErrors:(NSError *)error;

@end

