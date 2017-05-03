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

-(void)queryVideosWithType:(NSString *)type {
    NSMutableArray *cache = self.videosStored;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@search?part=snippet&order=date&safeSearch=moderate&key=%@&type=video&q=%@&videoDuration=short&videoEmbeddable=true", YOUTUBE_BASE, YOUTUBE_API_KEY, type]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *status = (NSHTTPURLResponse *)response;
        if (status.statusCode == 200) {
            NSArray *items = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"items"];
            if (items.count > 0) {
                for (NSDictionary *video in items) {
                    NSMutableDictionary *newvid = [[NSMutableDictionary alloc] init];
                    NSString *identifyer = [[video objectForKey:@"id"] objectForKey:@"videoId"];
                    NSDictionary *snippet = [video objectForKey:@"snippet"];
                    
                    if ([self videoExists:identifyer] == false) {
                        [newvid setObject:@{@"id":[snippet objectForKey:@"channelId"],
                                            @"name":[snippet objectForKey:@"channelTitle"]} forKey:@"channel"];
                        [newvid setObject:[snippet objectForKey:@"title"] forKey:@"title"];
                        [newvid setObject:[[[snippet objectForKey:@"thumbnails"] objectForKey:@"high"] objectForKey:@"url"] forKey:@"thumbnail"];
                        [newvid setObject:identifyer forKey:@"key"];
                        [newvid setObject:[snippet objectForKey:@"description"] forKey:@"description"];
                        [newvid setObject:[NSDate date] forKey:@"downloaded"];
                        [newvid setObject:[NSNumber numberWithBool:false] forKey:@"saved"];
                        [newvid setObject:[NSNumber numberWithBool:false] forKey:@"favorited"];
                        [newvid setObject:type forKey:@"type"];

                        [cache addObject:newvid];
                        
                    }
                    
                }
                
                [self.data setObject:cache forKey:@"video_cache"];
                [self.data setObject:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:@"video_cache_timestamp"];
                [self.data synchronize];
                
                if ([self.delegate respondsToSelector:@selector(queryingCompleteWithVideos)]) {
                    [self.delegate queryingCompleteWithVideos];
                    
                }

            }
            else {
                if ([self.delegate respondsToSelector:@selector(queryingReturnedErrors:)]) {
                    [self.delegate queryingReturnedErrors:nil];
                    
                }
                
            }
            
        }
        else {
            if ([self.delegate respondsToSelector:@selector(queryingReturnedErrors:)]) {
                [self.delegate queryingReturnedErrors:nil];
                
            }
            
        }
        
    }];
    
    [task resume];
    
    if ([self.delegate respondsToSelector:@selector(queryingVideos:)]) {
        [self.delegate queryingVideos];
        
    }
}

-(NSMutableArray *)videosStored {
    if ([[self.data objectForKey:@"video_cache"] count] == 0) return [[NSMutableArray alloc] init];
    else return [[self.data objectForKey:@"video_cache"] mutableCopy];
 
}
                        
-(BOOL)videoExists:(NSString *)identfyer {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@" ,identfyer];
    if ([[self.videosStored filteredArrayUsingPredicate:predicate] count] == 0) return false;
    else return true;
    
}
    
-(NSMutableArray *)videosSaved {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorited == 1"];
    return [[self.videosStored filteredArrayUsingPredicate:predicate] mutableCopy];
    
}

-(NSMutableArray *)videosWithType:(NSString *)type {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type CONTAINS %@" ,type];
    return [[self.videosStored filteredArrayUsingPredicate:predicate] mutableCopy];
    
}

@end
