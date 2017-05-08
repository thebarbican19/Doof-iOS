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

-(void)queryVideosWithType:(NSString *)type force:(BOOL)force {
    if (self.results == 0) self.results = 15;
    if (self.videoCacheExpired || force) {
        NSString *pagenation = self.nextpage==nil?@"":[NSString stringWithFormat:@"&pageToken=%@" ,self.nextpage];
        NSMutableArray *cache = self.videosDownloaded;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@search?part=snippet&order=date&safeSearch=moderate&key=%@&type=video&videoDuration=short&videoEmbeddable=true&maxResults=%d%@&q=%@", YOUTUBE_BASE, YOUTUBE_API_KEY ,self.results ,pagenation, type]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:APP_URL_TIMEOUT];
        [request setHTTPMethod:@"GET"];
        
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *status = (NSHTTPURLResponse *)response;
            if (status.statusCode == 200) {
                NSArray *items = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"items"];
                NSLog(@"Downloaded: %@" ,[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
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
                            [newvid setObject:[NSNumber numberWithBool:false] forKey:@"watched"];
                            [newvid setObject:[NSNumber numberWithBool:false] forKey:@"favorited"];
                            [newvid setObject:type forKey:@"type"];

                            [cache addObject:newvid];
                            
                        }
                        
                    }
                    
                    self.nextpage = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"nextPageToken"];
                    
                    [self.data setObject:cache forKey:@"video_cache"];
                    [self.data setObject:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:@"video_cache_timestamp"];
                    [self.data synchronize];
                    
                    if ([self.delegate respondsToSelector:@selector(queryingCompleteWithVideos)]) {
                        [self.delegate queryingCompleteWithVideos];
                        
                    }

                }
                else {
                    if ([self.delegate respondsToSelector:@selector(queryingReturnedErrors:)]) {
                        [self.delegate queryingReturnedErrors:[NSError errorWithDomain:[NSString stringWithFormat:@"There are no more %@ videos at this time" ,type] code:status.statusCode userInfo:nil]];
                        
                    }
                    
                }
                
            }
            else {
                if ([self.delegate respondsToSelector:@selector(queryingReturnedErrors:)]) {
                    [self.delegate queryingReturnedErrors:error];
                    
                }
                
            }
            
        }];
        
        [task resume];
        
        if ([self.delegate respondsToSelector:@selector(queryingVideos)]) {
            [self.delegate queryingVideos];
            
        }
        
    }
    else {
        NSLog(@"Cached");
        if ([self.delegate respondsToSelector:@selector(queryingCompleteWithVideos)]) {
            [self.delegate queryingCompleteWithVideos];
            
        }

    }
    
}

-(BOOL)videoCacheExpired {
    if ([self.data objectForKey:@"video_cache_timestamp"] == nil) return true;
    else if ([[NSDate date] compare:[self.data objectForKey:@"video_cache_timestamp"]] == NSOrderedDescending) return true;
    else return false;
    
}

-(NSMutableArray *)videosDownloaded {
    if ([[self.data objectForKey:@"video_cache"] count] == 0) return [[NSMutableArray alloc] init];
    else return [[self.data objectForKey:@"video_cache"] mutableCopy];
 
}
                        
-(BOOL)videoExists:(NSString *)identfyer {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@" ,identfyer];
    if ([[self.videosDownloaded filteredArrayUsingPredicate:predicate] count] == 0) return false;
    else return true;
    
}
    
-(NSMutableArray *)videosLiked {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorited == 1"];
    return [[self.videosDownloaded filteredArrayUsingPredicate:predicate] mutableCopy];
    
}

-(NSMutableArray *)videosUnwatched {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"watched == 0"];
    return [[self.videosDownloaded filteredArrayUsingPredicate:predicate] mutableCopy];
    
}

-(NSMutableArray *)videosWithType:(NSString *)type {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type CONTAINS %@" ,type];
    return [[self.videosDownloaded filteredArrayUsingPredicate:predicate] mutableCopy];
    
}

-(void)videoLikeWithData:(BOOL)like item:(NSDictionary *)item {
    NSMutableDictionary *updated = [[NSMutableDictionary alloc] initWithDictionary:item];
    [updated setObject:[NSNumber numberWithBool:like] forKey:@"favorited"];
    [updated setObject:[NSDate date] forKey:@"updated"];
    
    [self.videosDownloaded replaceObjectAtIndex:[self videoIndexFromData:item] withObject:updated];
    
    [self.data setObject:self.videosDownloaded forKey:@"video_cache"];
    [self.data synchronize];

}

-(void)videoWatchedWithData:(BOOL)watched item:(NSDictionary *)item {
    NSMutableDictionary *updated = [[NSMutableDictionary alloc] initWithDictionary:item];
    [updated setObject:[NSNumber numberWithBool:watched] forKey:@"watched"];
    [updated setObject:[NSDate date] forKey:@"updated"];
    
    [self.videosDownloaded replaceObjectAtIndex:[self videoIndexFromData:item] withObject:updated];
    
    [self.data setObject:self.videosDownloaded forKey:@"video_cache"];
    [self.data synchronize];
    
}

-(NSInteger)videoIndexFromData:(NSDictionary *)data {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key CONTAINS %@" ,[data objectForKey:@"key"]];
    NSUInteger index = [self.videosDownloaded indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        return [predicate evaluateWithObject:obj];
        
    }];
    
    return index;
    
}

@end
