//
//  GDMainNavigation.m
//  Grado
//
//  Created by Joe Barbour on 06/12/2015.
//  Copyright © 2015 NorthernSpark. All rights reserved.
//

#import "GDMainNavigation.h"
#import "DContstants.h"

@implementation GDMainNavigation

-(void)drawRect:(CGRect)rect {
    self.data = [[NSUserDefaults alloc] initWithSuiteName:APP_SAVE_DIRECTORY];
    if (![self.navigationContainer isDescendantOfView:self.superview]) {
        self.navigationContainer = [[UIView alloc] initWithFrame:self.bounds];
        self.navigationContainer.backgroundColor = [UIColor clearColor];
        [self addSubview:self.navigationContainer];
        
        self.navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, MAIN_NAVIGATION_HEIGHT)];
        self.navigationBar.backgroundColor = [UIColor clearColor];
        self.navigationBar.alpha = self.transparent?0.0:1.0;
        [self.navigationContainer addSubview:self.navigationBar];
        
        self.navigationLoader = [[UIView alloc] initWithFrame:CGRectMake(-self.bounds.size.width, MAIN_NAVIGATION_HEIGHT - 2.0, self.bounds.size.width, 2.0)];
        self.navigationLoader.backgroundColor = [UIColor clearColor];
        self.navigationLoader.alpha = 0.0;
        self.navigationLoader.layer.mask.anchorPoint = CGPointMake(0.0, 0.0);
        [self.navigationContainer addSubview:self.navigationLoader];
        
        self.navigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_NAVIGATION_BUTTONS_SIZE + 22.0, 20.0, self.bounds.size.width - (MAIN_NAVIGATION_BUTTONS_SIZE + MAIN_NAVIGATION_BUTTONS_SIZE + 50.0), MAIN_NAVIGATION_BUTTONS_SIZE)];
        self.navigationTitle.font = [UIFont fontWithName:@"VentiCF-DemiBold" size:13.0];
        self.navigationTitle.textAlignment = NSTextAlignmentCenter;
        self.navigationTitle.textColor = [UIColor whiteColor];
        self.navigationTitle.text = self.title.uppercaseString;
        self.navigationTitle.backgroundColor = [UIColor clearColor];
        [self.navigationContainer addSubview:self.navigationTitle];
        
        self.navigationLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(17.0, MAIN_NAVIGATION_MARGIN, self.navigationTitle.bounds.size.height, self.navigationTitle.bounds.size.height)];
        [self.navigationLeftButton setBackgroundColor:[UIColor clearColor]];
        [self.navigationLeftButton setHidden:!self.leftButton];
        [self.navigationLeftButton addTarget:self action:@selector(navigationLeftButtonWasTapped:)forControlEvents:UIControlEventTouchDown];
        [self.navigationContainer addSubview:self.navigationLeftButton];
        
        self.navigationLeftImage = [[UIImageView alloc] initWithFrame:self.navigationLeftButton.bounds];
        self.navigationLeftImage.contentMode = UIViewContentModeLeft;
        self.navigationLeftImage.image = self.leftImage;
        [self.navigationLeftButton addSubview:self.navigationLeftImage];
        
        /*
        self.navigationLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(17.0, MAIN_NAVIGATION_MARGIN, self.navigationTitle.bounds.size.height, self.navigationTitle.bounds.size.height)];
        [self.navigationLeftButton setBackgroundColor:[UIColor clearColor]];
        [self.navigationLeftButton setHidden:!self.leftButton];
        [self.navigationLeftButton addTarget:self action:@selector(navigationLeftButtonWasTapped:)forControlEvents:UIControlEventTouchDown];
        [self.navigationContainer addSubview:self.navigationLeftButton];
        */
        
        for (int i = 0;i < self.rightImages.count; i++) {
            NSLog(@"Images: %@" ,[self.rightImages objectAtIndex:i]);
            if ([[self.rightImages objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                self.navigationRightImage = [[UIImageView alloc] initWithFrame:self.navigationRightButton.bounds];
                self.navigationRightImage.contentMode = UIViewContentModeRight;
                self.navigationRightImage.image = [self.rightImages objectAtIndex:i];
                self.navigationRightImage.backgroundColor = [UIColor blueColor];
                [self.navigationContainer addSubview:self.navigationRightImage];

            }
            else if ([[self.rightImages objectAtIndex:i] isKindOfClass:[NSString class]]) {
                [self.navigationRightButton.titleLabel setFont:[UIFont fontWithName:@"VentiCF-Bold" size:11.0]];
                [self.navigationRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.navigationRightButton setTitle:[[self.rightImages objectAtIndex:i] uppercaseString] forState:UIControlStateNormal];
                [self.navigationContainer addSubview:self.navigationRightButton];

            }
            
        }
        
        self.navigationHairline = [[UIView alloc] initWithFrame:CGRectMake(0.0, MAIN_NAVIGATION_HEIGHT - 0.5, self.navigationBar.bounds.size.width, 0.5)];
        self.navigationHairline.backgroundColor = [UIColor clearColor];
        self.navigationHairline.alpha = self.transparent?0.0:1.0;
        [self.navigationContainer addSubview:self.navigationHairline];
        [self.navigationContainer bringSubviewToFront:self.navigationHairline];
        
        [UIView animateWithDuration:1.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
            self.navigationLoader.frame = CGRectMake(self.bounds.size.width, MAIN_NAVIGATION_HEIGHT - 2.0, self.bounds.size.width / 4, 2.0);
            
        } completion:nil];

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationLoader:) name:@"NotificationNavigationLoader" object:nil];

}

-(void)navigationLoader:(NSNotification *)notification {
    self.loading = [[notification.object objectForKey:@"animate"] boolValue];
    if (!self.transparent) {
        [UIView animateWithDuration:0.6 delay:self.loading?0.0:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (self.loading) self.navigationLoader.alpha = 1.0;
            else self.navigationLoader.alpha = 0.0;
                
        } completion:nil];
        
    }
    
}

-(void)navigationUpdateTitle:(NSString *)title {
    self.data = [[NSUserDefaults alloc] initWithSuiteName:APP_SAVE_DIRECTORY];
    if (![title.uppercaseString isEqualToString:self.navigationTitle.text] && title.length != 0) {
        titleFrame = CGRectMake(MAIN_NAVIGATION_BUTTONS_SIZE + 22.0, 20.0, self.bounds.size.width - (MAIN_NAVIGATION_BUTTONS_SIZE + MAIN_NAVIGATION_BUTTONS_SIZE + 50.0),MAIN_NAVIGATION_BUTTONS_SIZE);
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            titleFrame.origin.y =  20.0 - (MAIN_NAVIGATION_HEIGHT - 50.0);
            self.navigationTitle.frame = titleFrame;
            self.navigationTitle.alpha = 0.0;
            self.navigationTitle.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished) {
            titleFrame.origin.y = 20.0 + (MAIN_NAVIGATION_HEIGHT - 50.0);
            self.navigationTitle.frame = titleFrame;
            self.navigationTitle.text = title.uppercaseString;

            [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
                titleFrame.origin.y = 20.0;
                self.navigationTitle.frame = titleFrame;
                self.navigationTitle.alpha = 1.0;
                
            } completion:nil];
            
        }];
        
    }
    else {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.navigationTitle.transform = CGAffineTransformMakeScale(0.96, 0.96);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.navigationTitle.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
            } completion:nil];
            
        }];
        
    }
    
}

-(void)navigationButtonEnabled:(BOOL)enabled tag:(int)tag {
    [(UIButton *)[self viewWithTag:tag] setEnabled:enabled];

}

-(void)navigationButtonImage:(id)image tag:(int)tag {
    //if (tag > 0) [self.rightImages replaceObjectAtIndex:tag - 1 withObject:image];
    for (UIView *button in self.navigationContainer.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button.tag == tag) {
                if ([image isKindOfClass:[NSString class]]) {
                    NSString *text = image;
                    [(UIButton *)button setTitle:text.uppercaseString forState:UIControlStateNormal];

                }
                else {
                    for (UIView *item in button.subviews) {
                        if ([item isKindOfClass:[UIImageView class]]) [(UIImageView *)item setImage:(UIImage *)image];

                    }
                    
                }
                
            }
            
        }
        
    }
    
}

-(void)navigationLeftButtonWasTapped:(UIButton *)button {
    [self.delegate navigationLeftButtonWasTapped:button];
    
}

-(void)navigationButtonWasTapped:(UIButton *)button {
    [self.delegate navigationRightButtonWasTapped:button];
    
}

-(void)navigationAjustAlpha:(float)alpha {
    if (self.transparent) {
        self.navigationBar.alpha = alpha;
        self.navigationHairline.alpha = alpha;

    }
}

-(void)navigationAjustExtendedSize:(float)position animated:(BOOL)animated {
    [UIView animateWithDuration:animated?0.2:0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.navigationExtended setFrame:CGRectMake(0.0, 0.0 + position, self.bounds.size.width, MAIN_NAVIGATION_HEIGHT - MAIN_NAVIGATION_HEIGHT)];
        [self.navigationHairline setFrame:CGRectMake(0.0, 0.0 + position + (MAIN_NAVIGATION_HEIGHT - MAIN_NAVIGATION_HEIGHT), self.navigationBar.bounds.size.width, 0.5)];
        

    } completion:nil];

}

@end
