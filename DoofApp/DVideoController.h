//
//  DVideoController.h
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVideoObject.h"

@interface DVideoController : UIViewController <DVideoObjectDelegate>

@property (nonatomic, strong) DVideoObject *video;

@end
