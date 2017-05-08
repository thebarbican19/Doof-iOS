//
//  GDMainNavigation.h
//  Grado
//
//  Created by Joe Barbour on 06/12/2015.
//  Copyright © 2015 NorthernSpark. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDNavigationViewDelagate;
@interface GDMainNavigation : UIView {    
    CGRect titleFrame;
    CABasicAnimation *loaderWidth;
    CABasicAnimation *loaderPosition;

    
}

@property (nonatomic, strong) id <GDNavigationViewDelagate> delegate;

@property (nonatomic, strong) UIView *navigationHairline;
@property (nonatomic, strong) UIView *navigationContainer;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UIView *navigationExtended;
@property (nonatomic, strong) UILabel *navigationTitle;
@property (nonatomic, strong) UIButton *navigationLeftButton;
@property (nonatomic, strong) UIImageView *navigationLeftImage;
@property (nonatomic, strong) UIButton *navigationRightButton;
@property (nonatomic, strong) UIImageView *navigationRightImage;
@property (nonatomic, strong) UIButton *navigationLikeButton;
@property (nonatomic, strong) UIView *navigationLoader;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *colour;
@property (nonatomic) BOOL transparent;
@property (nonatomic) BOOL leftButton;
@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic) BOOL rightButton;
@property (nonatomic, strong) NSMutableArray *rightImages;
@property (nonatomic) BOOL likeButton;
@property (nonatomic) BOOL likeButtonSelected;
@property (nonatomic) BOOL loading;
@property (nonatomic ,strong) NSUserDefaults *data;

-(void)navigationAjustAlpha:(float)alpha;
-(void)navigationUpdateTitle:(NSString *)title;
-(void)navigationButtonEnabled:(BOOL)enabled tag:(int)tag;
-(void)navigationButtonImage:(id)image tag:(int)tag;
-(void)navigationLoader:(NSNotification *)notification;

@end

@protocol GDNavigationViewDelagate <NSObject>

@optional

-(void)navigationLeftButtonWasTapped:(UIButton *)button;
-(void)navigationRightButtonWasTapped:(UIButton *)button;

@end
