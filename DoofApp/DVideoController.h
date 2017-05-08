//
//  DVideoController.h
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVideoObject.h"
#import "DVideoCell.h"
#import "GDMainNavigation.h"
#import "Mixpanel/Mixpanel.h"

@interface DVideoController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, DVideoObjectDelegate, DVideoCellDelegate, GDNavigationViewDelagate>

@property (nonatomic, strong) DVideoObject *video;
@property (nonatomic, strong) IBOutlet UICollectionView *collection;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) IBOutlet GDMainNavigation *navigation;

@property (nonatomic, assign) NSIndexPath *cell;
@property (nonatomic, assign) BOOL statusbar;

@end
