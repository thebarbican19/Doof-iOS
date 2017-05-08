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

-(void)viewDidAppear:(BOOL)animated {
    [self setNeedsStatusBarAppearanceUpdate];
    [self scrollViewDidEndDecelerating:self.collection];
    
}

-(void)viewDidLayoutSubviews {
    if ([[UIApplication sharedApplication] statusBarOrientation]!=UIInterfaceOrientationPortrait) self.statusbar = true;
    else self.statusbar = false;
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self.collection setFrame:self.view.bounds];
    [self.layout setItemSize:CGSizeMake(self.view.bounds.size.width - 1.0, self.view.bounds.size.height)];
    [self.layout setSectionInset:UIEdgeInsetsMake(self.statusbar?0.0:-20.0, 0.5, 0.0, 0.0)];
    [self.layout invalidateLayout];
    
    for (NSIndexPath *index in [self.collection indexPathsForVisibleItems]) {
        DVideoCell *cell = (DVideoCell *)[self.collection cellForItemAtIndexPath:index];
        [cell orentation:[[UIApplication sharedApplication] statusBarOrientation]];
        
    }

}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.video = [[DVideoObject alloc] init];
    self.video.delegate = self;
        
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    self.navigationController.navigationBarHidden = true;
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumLineSpacing = 1.0;
    self.layout.sectionInset = UIEdgeInsetsMake(-20.0, 0.5, 0.0, 0.0);
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.itemSize = CGSizeMake(self.view.bounds.size.width - 1.0, self.view.bounds.size.height);
    
    self.collection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
    self.collection.collectionViewLayout = self.layout;
    self.collection.pagingEnabled = true;
    self.collection.backgroundColor = [UIColor clearColor];
    self.collection.bounces = false;
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection registerClass:[DVideoCell class] forCellWithReuseIdentifier:@"video"];
    [self.view addSubview:self.collection];
    
    self.navigation = [[GDMainNavigation alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, MAIN_NAVIGATION_HEIGHT)];
    self.navigation.backgroundColor = [UIColor redColor];
    self.navigation.delegate = self;
    self.navigation.title = nil;
    self.navigation.transparent = true;
    self.navigation.leftButton = true;
    self.navigation.leftImage = nil;
    self.navigation.rightButton = true;
    self.navigation.rightImages = @[[UIImage imageNamed:@"NavigationLike"], [UIImage imageNamed:@"NavigationShare"]].mutableCopy;
    //[self.view addSubview:self.navigation];

}

-(void)viewPlayNextVideo:(DVideoCell *)content {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:content.index.row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
        
    } completion:nil];
    
    [self scrollViewDidEndDecelerating:self.collection];

}

-(void)viewPlaybackBegan:(DVideoCell *)content {
    //DVideoCell *cell = (DVideoCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:content.index.row + 1 inSection:0]];
    
    //[self.mixpanel timeEvent:@"Video Played"];

}

-(void)queryingVideos {
    NSLog(@"Downloading...");
    
}

-(void)queryingCompleteWithVideos {
    [self.collection reloadData];
    
}

-(void)queryingReturnedErrors:(NSError *)error {
    int index;
    if (self.video.videosUnwatched.count == 0) index = 0;
    else index = (int)self.video.videosUnwatched.count + 1;
    
    //DVideoCell *cell = (DVideoCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    //[cell.label setText:error.localizedDescription];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.video.videosUnwatched.count + 1;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DVideoCell *cell = (DVideoCell *)[self.collection dequeueReusableCellWithReuseIdentifier:@"video" forIndexPath:indexPath];

    if (indexPath.row >= self.video.videosUnwatched.count) [cell loading:true];
    else [cell setup:[self.video.videosUnwatched objectAtIndex:indexPath.row] index:indexPath];

    [cell setDelegate:self];
    [cell.contentView setBackgroundColor:[UIColor blackColor]];
    [cell.contentView setClipsToBounds:true];
    [cell.contentView.layer setCornerRadius:1];

    return cell;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (NSIndexPath *index in [self.collection indexPathsForVisibleItems]) {
        DVideoCell *cell = (DVideoCell *)[self.collection cellForItemAtIndexPath:index];
        [cell.player.player pause];
        
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    for (NSIndexPath *index in [self.collection indexPathsForVisibleItems]) {
        DVideoCell *cell = (DVideoCell *)[self.collection cellForItemAtIndexPath:index];
        if (cell.loading == false) {
            if (self.cell.row != index.row) [cell play];
            else [cell.player.player play];
            
            [self setCell:index];
            
        }
        else {
            [cell stop];
            [self.video queryVideosWithType:@"cute,animals,puppies" force:true];
            
        }
        
    }
    
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
    
}

-(BOOL)prefersStatusBarHidden {
    return self.statusbar;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}

-(BOOL)shouldAutorotate {
    return true;
    
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscape;
    
}

@end
