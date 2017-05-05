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

@protocol DVideoCellDelegate;
@interface DVideoCell : UICollectionViewCell

@property (nonatomic, strong) id <DVideoCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIImageView *background;
@property (nonatomic, strong) IBOutlet UIView *overlay;
@property (nonatomic, strong) IBOutlet SAMLabel *label;
@property (nonatomic, strong) IBOutlet AVPlayerViewController *player;

@property (nonatomic, strong) NSURL *stream;
@property (nonatomic, strong) NSDictionary *item;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) NSIndexPath *index;
@property (nonatomic, assign) NSTimer *timer;

-(void)setup:(NSDictionary *)item index:(NSIndexPath *)index;
-(void)download:(NSString *)key autoplay:(BOOL)autoplay;
-(void)loading:(BOOL)loading;
-(void)play;
-(void)stop;

@end

@protocol DVideoCellDelegate <NSObject>

@optional

-(void)viewPlayNextVideo:(DVideoCell *)content;

@end

