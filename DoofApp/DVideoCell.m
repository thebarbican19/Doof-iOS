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
        self.background = [[UIImageView alloc] initWithFrame:self.bounds];
        self.background.contentMode = UIViewContentModeScaleAspectFill;
        self.background.image = nil;
        self.background.backgroundColor = [UIColor clearColor];
        self.background.clipsToBounds = true;
        [self.contentView addSubview:self.background];
        
        self.overlay = [[UIView alloc] initWithFrame:self.background.bounds];
        self.overlay.backgroundColor = [MAIN_OVERLAY_COLOR colorWithAlphaComponent:0.7];
        [self.contentView addSubview:self.overlay];

        self.label = [[SAMLabel alloc] initWithFrame:CGRectMake(20, self.overlay.center.y - 70.0, self.overlay.bounds.size.width - 40.0, 140.0)];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont fontWithName:@"Cabin-Bold" size:20];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.numberOfLines = 5;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.verticalTextAlignment = UIControlContentVerticalAlignmentCenter;
        [self.overlay addSubview:self.label];
        
        self.player = [[AVPlayerViewController alloc] init];
        self.player.view.frame = self.background.bounds;
        self.player.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.player.showsPlaybackControls = false;
        self.player.view.backgroundColor = [UIColor clearColor];
        self.player.allowsPictureInPicturePlayback = true;
        self.player.player.allowsExternalPlayback = false;
        self.player.view.userInteractionEnabled = false;
        [self.background addSubview:self.player.view];

    }
    
    return self;
    
}

-(void)setup:(NSDictionary *)item index:(NSIndexPath *)index {
    if (self.item == nil) self.item = item;
    if (self.index == nil) self.index = index;
    
    [self stop];
    [self image:[NSURL URLWithString:[item objectForKey:@"thumbnail"]]];
    [self download:[item objectForKey:@"key"] autoplay:self.index.row==0?true:false];
    [self loading:false];
    
    [self.label setAttributedText:[self format:[item objectForKey:@"title"] description:[item objectForKey:@"description"]]];
    
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
            self.stream = [NSURL URLWithString:url];
            
            if (autoplay) [self play];
            
        }];
        
    });
    
}

-(void)loading:(BOOL)loading {
    [self setLoading:loading];
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.overlay setBackgroundColor:loading?MAIN_OVERLAY_COLOR:[MAIN_OVERLAY_COLOR colorWithAlphaComponent:0.7]];
        
    } completion:^(BOOL finished) {
        if (loading) [self.label setAttributedText:[self format:@"Loading" description:@"Please wait"]];
        
    }];
    
}

-(void)play {
    if (self.stream == nil) [self download:[self.item objectForKey:@"key"] autoplay:true];
    else {
        [self.player setPlayer:[[AVPlayer alloc] initWithURL:self.stream]];
        [self.player.player play];
        [self.player.player setMuted:false];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(status) userInfo:nil repeats:true];
       
    }

}

-(void)stop {
    [self.player.player pause];
    [self.player setPlayer:nil];
    
}

-(void)status {
    if (CMTimeGetSeconds(self.player.player.currentItem.currentTime) >= CMTimeGetSeconds(self.player.player.currentItem.duration)) {
        [self.timer invalidate];
        [self.delegate viewPlayNextVideo:self];
        
    }

}

-(NSAttributedString *)format:(NSString *)title description:(NSString *)description {
    NSString *format = [NSString stringWithFormat:@"%@\n%@" ,title, description];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:format];
    [attribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Cabin-Medium" size:12] range:NSMakeRange(title.length, description.length + 1)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1.0 alpha:0.8] range:NSMakeRange(title.length, description.length + 1)];

    return attribute;
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"Key Path: %@" ,keyPath);
    if ([keyPath isEqualToString:@"status"]) {
        
    }
    
}

-(void)dealloc {
    [self stop];

    
}

@end
