//
//  DVideoController.h
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVideoObject.h"

@interface DVideoController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, DVideoObjectDelegate>

@property (nonatomic, strong) DVideoObject *video;
@property (nonatomic, strong) IBOutlet UICollectionView *collection;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSIndexPath *cell;

@end
