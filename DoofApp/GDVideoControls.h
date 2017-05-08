//
//  GDVideoControls.h
//  Grado
//
//  Created by Joe Barbour on 14/04/2016.
//  Copyright © 2016 NorthernSpark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDSlider.h"

@protocol GDVideoControlsDelegate;
@interface GDVideoControls : UIView

@property (nonatomic, strong) id <GDVideoControlsDelegate> delegate;
@property (nonatomic, strong) GDSlider *controlProgress;
@property (nonatomic, strong) UILabel *controlLabel;
@property (nonatomic, strong) UIButton *controlPlayPause;

@property (nonatomic) float duration;
@property (nonatomic) BOOL autoplay;

-(void)controlsUpdateProgress:(float)progress;

@end

@protocol GDVideoControlsDelegate <NSObject>

@optional

-(void)controlsBeginSeeking;
-(void)controlsEndSeeking:(float)position;
-(void)controlsTogglePlayback:(BOOL)playing;

@end

