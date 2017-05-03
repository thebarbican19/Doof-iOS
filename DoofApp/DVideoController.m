//
//  DVideoController.m
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import "DVideoController.h"
#import "DContstants.h"

@interface DVideoController ()

@end

@implementation DVideoController

-(void)viewWillAppear:(BOOL)animated {
    [self setNeedsStatusBarAppearanceUpdate];

}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.video = [[DVideoObject alloc] init];
    self.video.delegate = self;
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    self.navigationController.navigationBarHidden = true;
    
    NSLog(@"Videos: %@" ,self.video.videosStored);
    
}

-(void)queryingVideos {
    NSLog(@"Downloading...");
    
}

-(void)queryingCompleteWithVideos {
    
}

-(void)queryingReturnedErrors:(NSError *)error {
    
}

-(BOOL)prefersStatusBarHidden {
    return false;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}

@end
