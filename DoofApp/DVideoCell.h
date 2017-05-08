//
//  DVideoCell.h
//  DoofApp
//
//  Created by Joe Barbour on 03/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "UIImageView+WebCache.h"
#import "SAMLabel.h"
#import "DaiYoutubeParser.h"
#import "BLMultiColorLoader.h"
#import "GDVideoControls.h"
#import "Mixpanel/Mixpanel.h"

@protocol DVideoCellDelegate;
@interface DVideoCell : UICollectionViewCell <GDVideoControlsDelegate> {
    CGRect titlerect;
    CGRect subtitlerect;
    CGRect informationrect;
}

@property (nonatomic, strong) id <DVideoCellDelegate> delegate;
@property (nonatomic, strong) Mixpanel *mixpanel;
@property (nonatomic, strong) IBOutlet UIImageView *background;
@property (nonatomic, strong) IBOutlet UIView *overlay;
@property (nonatomic, strong) IBOutlet SAMLabel *title;
@property (nonatomic, strong) IBOutlet SAMLabel *subtitle;
@property (nonatomic, strong) IBOutlet SAMLabel *information;
@property (nonatomic, strong) IBOutlet BLMultiColorLoader *loader;
@property (nonatomic, strong) IBOutlet GDVideoControls *controls;
@property (nonatomic, strong) IBOutlet AVPlayerViewController *player;
@property (nonatomic, strong) UIVisualEffectView *effect;

@property (nonatomic, strong) NSURL *stream;
@property (nonatomic, strong) NSDictionary *item;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, assign) NSIndexPath *index;
@property (nonatomic, assign) NSTimer *timer;

-(void)setup:(NSDictionary *)item index:(NSIndexPath *)index;
-(void)download:(NSString *)key autoplay:(BOOL)autoplay;
-(void)loading:(BOOL)loading;
-(void)play;
-(void)stop;
-(void)text:(BOOL)animated;
-(void)orentation:(UIInterfaceOrientation)orentation;

@end

@protocol DVideoCellDelegate <NSObject>

@optional

-(void)viewPlaybackBegan:(DVideoCell *)content;
-(void)viewPlayNextVideo:(DVideoCell *)content;

@end

