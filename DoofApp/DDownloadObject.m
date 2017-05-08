//
//  DDownloadObject.m
//  DoofApp
//
//  Created by Joe Barbour on 06/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import "DDownloadObject.h"
#import "DContstants.h"

@implementation DDownloadObject

-(instancetype)init {
    self = [super init];
    if (self) {
        self.data =  [[NSUserDefaults alloc] initWithSuiteName:APP_SAVE_DIRECTORY];
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        
    }
    return self;
    
}

-(void)videoDownloadFromStream:(NSURL *)stream key:(NSString *)key {
    if (key.length == 11) {
        self.filename =  [NSString stringWithFormat:@"%@.mp4" ,key];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:stream cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:APP_URL_TIMEOUT];
        NSURLSessionDownloadTask *download = [self.session downloadTaskWithRequest:request];

        [download resume];
        
    }
    else NSLog(@"Key %@ Invalid", key);
    
}

-(void)videoMergeWithPromo {
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)currentTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {

}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {

}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)download didFinishDownloadingToURL:(NSURL *)location {
    if ([[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:[APP_DOWNLOAD_DIRECTORY stringByAppendingPathComponent:self.filename]] error:nil]) {
        
    }

}

-(void)downloadDidReceiveError:(NSError *)error response:(NSHTTPURLResponse *)response {

}

@end
