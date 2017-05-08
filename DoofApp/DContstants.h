//
//  DContstants.h
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define NSColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#ifdef DEBUG
    #define APP_DEBUG_MODE true

#else
    #define APP_DEBUG_MODE false

#endif

#define MAIN_BACKGROUND_COLOR NSColor(0x2B2A34)
#define MAIN_OVERLAY_COLOR NSColor(0x100F1C)
#define MAIN_NAVIGATION_HEIGHT 74.0
#define MAIN_NAVIGATION_MARGIN 18.0
#define MAIN_NAVIGATION_BUTTONS_SIZE MAIN_NAVIGATION_HEIGHT - 25.5
#define MAIN_STATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#define YOUTUBE_BASE @"https://www.googleapis.com/youtube/v3/"
#define YOUTUBE_API_KEY @"AIzaSyAd1GZzG35p5d6UCUtpMK3ZngG8p3BAoHQ"
#define YOUTUBE_IPHONE_USER_AGENT @"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3"
#define YOUTUBE_WATCH_URL @"https://www.youtube.com/watch?v="
#define YOUTUBE_VIDEO_EXTRACT_REGEX @"(?!\\\\\")http[^\"]*?itag=[^\"]*?(?=\\\\\")"

#define APP_DOWNLOAD_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_MIXPANEL_TOKEN @"fa41eb7bad08279a065d6dde32c45383"
//#define APP_STORE_URL @"https://itunes.apple.com/us/app/all-hours/id1000983835?ls=1&mt=8"
//#define APP_STORE_ID @"1000983835"
#define APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey]
#define APP_SAVE_DIRECTORY @"group.com.northernspark.doofapp"
#define APP_DEVICE [[[UIDevice currentDevice] systemVersion] floatValue]
#define APP_LANGUAGE [[NSLocale preferredLanguages] objectAtIndex:0]
#define APP_DEVICE_NAME [[UIDevice currentDevice] name];
#define APP_URL_TIMEOUT 15

