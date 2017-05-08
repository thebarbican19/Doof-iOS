//
//  GDVideoControls.m
//  Grado
//
//  Created by Joe Barbour on 14/04/2016.
//  Copyright © 2016 NorthernSpark. All rights reserved.
//

#import "GDVideoControls.h"

@implementation GDVideoControls

-(void)drawRect:(CGRect)rect {
    if (![self.controlProgress isDescendantOfView:self.superview]) {
        self.controlProgress = [[GDSlider alloc] initWithFrame:CGRectMake(70.0, (self.bounds.size.height / 2) - 4.0, self.bounds.size.width - 140.0, 8.0)];
        self.controlProgress.minimumValue = 0.0;
        self.controlProgress.maximumValue = 60.0;
        self.controlProgress.value = 0.0;
        self.controlProgress.minimumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        self.controlProgress.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.45];
        self.controlProgress.backgroundColor = [UIColor clearColor];
        [self.controlProgress setThumbImage:[UIImage imageNamed:@"VideoSeekerIcon"] forState:UIControlStateNormal];
        [self.controlProgress addTarget:self action:@selector(controlsSliderChanged:) forControlEvents:UIControlEventValueChanged];
        [self.controlProgress addTarget:self action:@selector(controlsSliderTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.controlProgress];

        self.controlLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 70.0, 0.0, 70.0, self.bounds.size.height)];
        self.controlLabel.text = [NSString stringWithFormat:@"-%02d:%02d" ,(int)self.duration / 60, (int)self.duration % 60];
        self.controlLabel.textAlignment = NSTextAlignmentCenter;
        self.controlLabel.textColor = [UIColor whiteColor];
        self.controlLabel.font = [UIFont fontWithName:@"VentiCF-DemiBold" size:13.0];
        self.controlLabel.userInteractionEnabled = false;
        [self addSubview:self.controlLabel];
        
        self.controlPlayPause = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 70.0, self.bounds.size.height)];
        self.controlPlayPause.tag = 1;
        [self.controlPlayPause setImage:[UIImage imageNamed:self.autoplay?@"VideoPauseIcon":@"VideoPlayIcon"] forState:UIControlStateNormal];
        [self.controlPlayPause addTarget:self action:@selector(controlsToggleTouched:)forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.controlPlayPause];

    }
    
}

-(void)controlsToggleTouched:(UIButton *)button {
    if ([[button imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"VideoPauseIcon"]]) {
        [self.controlPlayPause setImage:[UIImage imageNamed:@"VideoPlayIcon"] forState:UIControlStateNormal];
        [self.delegate controlsTogglePlayback:true];

    }
    else {
        [self.controlPlayPause setImage:[UIImage imageNamed:@"VideoPauseIcon"] forState:UIControlStateNormal];
        [self.delegate controlsTogglePlayback:false];

    }

}

-(void)controlsSliderTouched:(UISlider *)slider {
    [self.delegate controlsBeginSeeking];

}

-(void)controlsSliderChanged:(UISlider *)slider {
    [self.delegate controlsEndSeeking:slider.value];
    
}

-(void)controlsUpdateProgress:(float)progress {
    if (progress > 0) {
        [self.controlProgress setValue:progress animated:true];
        [self.controlProgress setMaximumValue:self.duration];
        [self.controlLabel setText:[NSString stringWithFormat:@"-%02d:%02d" ,((int)self.duration - (int)progress) / 60, ((int)self.duration - (int)progress) % 60]];
    }

}

@end
