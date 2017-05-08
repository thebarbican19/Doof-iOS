//
//  DVideoCell.m
//  DoofApp
//
//  Created by Joe Barbour on 03/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import "DVideoCell.h"
#import "DContstants.h"

@implementation DVideoCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mixpanel = [Mixpanel sharedInstance];

        self.background = [[UIImageView alloc] initWithFrame:self.bounds];
        self.background.contentMode = UIViewContentModeScaleAspectFill;
        self.background.image = nil;
        self.background.backgroundColor = [UIColor clearColor];
        self.background.clipsToBounds = true;
        [self.contentView addSubview:self.background];
        
        self.overlay = [[UIView alloc] initWithFrame:self.background.bounds];
        self.overlay.backgroundColor = [MAIN_OVERLAY_COLOR colorWithAlphaComponent:0.3];
        [self.contentView addSubview:self.overlay];
        
        self.effect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        self.effect.frame = self.overlay.bounds;
        [self.overlay addSubview:self.effect];

        self.loader = [[BLMultiColorLoader alloc] initWithFrame:CGRectMake(65.0, 115.0, 15.0, 15.0)];
        self.loader.backgroundColor = [UIColor orangeColor];
        self.loader.lineWidth = 1.0;
        self.loader.colorArray = @[[UIColor whiteColor]];
        [self.overlay addSubview:self.loader];
        
        self.information = [[SAMLabel alloc] initWithFrame:CGRectMake(65.0, 115.0, self.overlay.bounds.size.width - 130.0, 15.0)];
        self.information.textColor = [UIColor colorWithWhite:0.95 alpha:0.8];
        self.information.font = [UIFont fontWithName:@"VentiCF-Bold" size:9];
        self.information.textAlignment = NSTextAlignmentLeft;
        self.information.tag = 2;
        self.information.numberOfLines = 1;
        self.information.backgroundColor = [UIColor clearColor];
        self.information.verticalTextAlignment = UIControlContentVerticalAlignmentTop;
        self.information.attributedText = nil;
        [self.overlay addSubview:self.information];
        
        self.title = [[SAMLabel alloc] initWithFrame:CGRectMake(65.0, 130.0, self.overlay.bounds.size.width - 130.0, 140.0)];
        self.title.textColor = [UIColor whiteColor];
        self.title.font = [UIFont fontWithName:@"VentiCF-Bold" size:25];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.tag = 1;
        self.title.alpha = 0.0;
        self.title.numberOfLines = 10;
        self.title.backgroundColor = [UIColor clearColor];
        self.title.verticalTextAlignment = UIControlContentVerticalAlignmentTop;
        [self.overlay addSubview:self.title];
        
        self.subtitle = [[SAMLabel alloc] initWithFrame:CGRectMake(65.0, 180.0, self.overlay.bounds.size.width - 130.0, 140.0)];
        self.subtitle.textColor = [UIColor whiteColor];
        self.subtitle.font = [UIFont fontWithName:@"VentiCF-Medium" size:14];
        self.subtitle.textAlignment = NSTextAlignmentLeft;
        self.subtitle.tag = 1;
        self.subtitle.alpha = 0.0;
        self.subtitle.numberOfLines = 10;
        self.subtitle.backgroundColor = [UIColor clearColor];
        self.subtitle.verticalTextAlignment = UIControlContentVerticalAlignmentTop;
        [self.overlay addSubview:self.subtitle];
        
        self.player = [[AVPlayerViewController alloc] init];
        self.player.view.frame = self.background.bounds;
        self.player.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.player.showsPlaybackControls = false;
        self.player.view.backgroundColor = [UIColor clearColor];
        self.player.allowsPictureInPicturePlayback = true;
        self.player.player.allowsExternalPlayback = false;
        self.player.view.userInteractionEnabled = false;
        [self.background addSubview:self.player.view];

        self.controls = [[GDVideoControls alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height - 75.0, self.bounds.size.width, 75.0)];
        self.controls.backgroundColor = [UIColor clearColor];
        self.controls.delegate = self;
        self.controls.autoplay = true;
        self.controls.alpha = 1.0;
        [self addSubview:self.controls];

    }
    
    informationrect = self.information.frame;
    titlerect = self.title.frame;
    subtitlerect = self.subtitle.frame;

    return self;
    
}

-(void)setup:(NSDictionary *)item index:(NSIndexPath *)index {
    if (self.item == nil) self.item = item;
    if (self.index == nil) self.index = index;
    
    [self stop];
    [self image:[NSURL URLWithString:[item objectForKey:@"thumbnail"]]];
    [self download:[item objectForKey:@"key"] autoplay:self.index.row==0?true:false];
    [self loading:false];
    [self text:true];
    
}

-(void)text:(BOOL)animated {
    self.title.attributedText = [self format:[[self.item objectForKey:@"title"] uppercaseString] label:self.title];
    self.title.backgroundColor = [UIColor redColor];
    
    titlerect.size.width = (self.bounds.size.width - 130.0);
    titlerect.size.height = [self sframe:self.title];
    titlerect.origin.y = 100.0;
    
    informationrect.size.width = (self.bounds.size.width - 130.0);
    informationrect.origin.y = 85.0;
    
    [UIView animateWithDuration:animated?0.4:0.0 delay:animated?0.05:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.title.frame = titlerect;
        self.title.alpha = 1.0;
        self.information.frame = informationrect;
        
    } completion:nil];

}

-(float)sframe:(SAMLabel *)label {
    return [label.attributedText boundingRectWithSize:CGSizeMake(self.bounds.size.width - 130.0, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size.height + 70.0;
    
    
}


-(void)image:(NSURL *)image {
    [self.background sd_setImageWithURL:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.background setImage:image];
            
        }
        
    }];
    
}

-(void)download:(NSString *)key autoplay:(BOOL)autoplay {
    dispatch_async(dispatch_get_global_queue(autoplay?DISPATCH_QUEUE_PRIORITY_HIGH:DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [DaiYoutubeParser parse:key screenSize:self.bounds.size videoQuality:DaiYoutubeParserQualityHighres completion:^(DaiYoutubeParserStatus status, NSString *url, NSString *videoTitle, NSNumber *videoDuration) {
            if (url) {
                self.stream = [NSURL URLWithString:url];
                
                if (autoplay) [self play];
                
            }
            else NSLog(@"Error, could not load stream");
            
        }];
        
    });
    
}

-(void)loading:(BOOL)loading {
    if (loading) informationrect.origin.x = 65.0 + 22.0;
    else informationrect.origin.x = 65.0;
    
    [self setLoading:loading];
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.information setFrame:informationrect];
        [self.overlay setBackgroundColor:loading?MAIN_OVERLAY_COLOR:[MAIN_OVERLAY_COLOR colorWithAlphaComponent:0.7]];
        
    } completion:^(BOOL finished) {
        if (loading) {
            [self.information setAttributedText:[self format:NSLocalizedString(@"VideoLoading_Title", nil).uppercaseString label:self.information]];
            [self.loader startAnimation];
            
        }
        else {
            [self.information setAttributedText:[self format:[self.item objectForKey:@"type"] label:self.information]];
            [self.loader stopAnimation];
            
        }

        
    }];
    
}

-(void)play {
    if (self.stream == nil) [self download:[self.item objectForKey:@"key"] autoplay:true];
    else {
        [self.player.player.currentItem removeObserver:self forKeyPath:@"status"];
        [self.player.player.currentItem removeObserver:self forKeyPath:@"rate"];
        [self.player.player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        
        [self.player setPlayer:[[AVPlayer alloc] initWithURL:self.stream]];
        [self.player.player play];
        [self.player.player setMuted:APP_DEBUG_MODE];
        
        [self.player.player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) context:nil];
        [self.player.player.currentItem addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
        [self.player.player.currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(status) userInfo:nil repeats:true];
       
    }

}

-(void)stop {
    [self.player.player pause];
    [self.player setPlayer:nil];
    
    [self.mixpanel clearTimedEvents];

}

-(void)status {
    if (CMTimeGetSeconds(self.player.player.currentItem.currentTime) >= CMTimeGetSeconds(self.player.player.currentItem.duration)) {
        [self.timer invalidate];
        [self.delegate viewPlayNextVideo:self];
        
    }
    
    if (self.player.player.rate != 0 && self.player.player.error == nil && self.playing == false) {
        [self setPlaying:true];
        [self.delegate viewPlaybackBegan:self];
        
        /*
         [self.mixpanel track:@"Video Played" properties:@{@"Title":[self.item objectForKey:@"title"],
         @"Until End":[NSNumber numberWithBool:true],
         @"Key":[self.item objectForKey:@"key"],
         @"Orientation":[[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait?@"Portrait":@"Landscape"}];
        */
        
    }
    else [self setPlaying:true];


}

-(void)orentation:(UIInterfaceOrientation)orentation {
    [self.overlay setFrame:self.contentView.bounds];
    [self.effect setFrame:self.contentView.bounds];
    [self.background setFrame:self.contentView.bounds];
    [self.player setVideoGravity:orentation==UIInterfaceOrientationPortrait?AVLayerVideoGravityResizeAspectFill:AVLayerVideoGravityResize];
    [self.player.view setFrame:self.background.bounds];
    [self text:false];
    
}

-(NSAttributedString *)format:(NSString *)text label:(SAMLabel *)label  {
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:text];
    if (label.tag == 1) {
        [attribute addAttribute:NSKernAttributeName value:@(2) range:NSMakeRange(0, text.length)];
        
    }
    
    return attribute;

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"Key Path: %@" ,keyPath);
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.player.status == AVPlayerStatusReadyToPlay) {
            [self.controls setDuration:CMTimeGetSeconds(self.player.player.currentItem.duration)];
            [self.controls.controlPlayPause setImage:[UIImage imageNamed:@"GalleryPauseIcon"] forState:UIControlStateNormal];

        }
        else if (self.player.player.status == AVPlayerStatusFailed) {
            
        }
        else {
            
        }
        
    }
    
    if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        if (self.player.player.currentItem.playbackLikelyToKeepUp == true && CMTimeGetSeconds(self.player.player.currentItem.duration) > 0) {
            [self.controls.controlPlayPause setImage:[UIImage imageNamed:@"GalleryPauseIcon"] forState:UIControlStateNormal];
            
        }
        
    }
    
    if ([keyPath isEqualToString:@"rate"]) {
        //if (self.player.player.rate) [self performSelector:@selector(gestureReveal:) withObject:nil afterDelay:3.0];
        
    }
    
    
}

-(void)dealloc {
    [self stop];

}

@end
