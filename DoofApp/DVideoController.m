//
//  DVideoController.m
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import "DVideoController.h"
#import "DVideoCell.h"
#import "DContstants.h"

@interface DVideoController ()

@end

@implementation DVideoController

-(void)viewDidAppear:(BOOL)animated {
    [self setNeedsStatusBarAppearanceUpdate];
    [self scrollViewDidEndDecelerating:self.collection];
    
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
    
    self.collection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
    self.collection.collectionViewLayout = self.layout;
    self.collection.pagingEnabled = true;
    self.collection.backgroundColor = [UIColor clearColor];
    self.collection.bounces = false;
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection registerClass:[DVideoCell class] forCellWithReuseIdentifier:@"video"];
    [self.view addSubview:self.collection];
    
    //[self.video videoCacheDestroy];
    //[self.video queryVideosWithType:@"cute+animals"];
    
}

-(void)queryingVideos {
    NSLog(@"Downloading...");
    
}

-(void)queryingCompleteWithVideos {
    [self.collection reloadData];
    
}

-(void)queryingReturnedErrors:(NSError *)error {
    DVideoCell *cell = (DVideoCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.video.videosStored.count + 1 inSection:0]];
    [cell.label setText:error.localizedDescription];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.video.videosStored.count + 1;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width - 1.0, self.view.bounds.size.height);

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DVideoCell *cell = (DVideoCell *)[self.collection dequeueReusableCellWithReuseIdentifier:@"video" forIndexPath:indexPath];
    

    if (indexPath.row >= self.video.videosStored.count) [cell loading:true];
    else [cell setup:[self.video.videosStored objectAtIndex:indexPath.row] index:indexPath];

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
        NSLog(@"Index Called %@ Set Cell %@" ,index ,self.cell)
        DVideoCell *cell = (DVideoCell *)[self.collection cellForItemAtIndexPath:index];
        if (cell.loading == false) {
            if (self.cell.row != index.row) [cell play];
            else [cell.player.player play];
            
            [self setCell:index];
            
        }
        else {
            [cell stop];
            [self.video queryVideosWithType:@"cute+animals"];
            //ADD PAGE NUMBER
            //STOP MULTIPLE CALLS TO YOUTUBE IF SCROLLED
            
        }
        
    }
    
}

-(BOOL)prefersStatusBarHidden {
    return false;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}

@end
