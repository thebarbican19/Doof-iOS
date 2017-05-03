//
//  DVideoObject.m
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import "DVideoObject.h"
#import "DContstants.h"

@implementation DVideoObject

-(instancetype)init {
    self = [super init];
    if (self) {
        self.data =  [[NSUserDefaults alloc] initWithSuiteName:APP_SAVE_DIRECTORY];
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        

    }
    return self;
    
}

-(void)queryVideosWithType:(NSString *)type completion:(void (^)(NSError *error, NSArray *videos))completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@search?part=snippet&order=date&safeSearch=moderate&type=video&q=%@", YOUTUBE_BASE, type]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    NSLog(@"Calling: %@" ,url);
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSHTTPURLResponse *status = (NSHTTPURLResponse *)response;
        
    }];
    
    [task resume];
}



@end
