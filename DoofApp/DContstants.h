//
//  DContstants.h
//  DoofApp
//
//  Created by Joe Barbour on 02/05/2017.
//  Copyright © 2017 NorthernSpark. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
    #define APP_DEBUG_MODE true

#else
    #define APP_DEBUG_MODE false

#endif

#define YOUTUBE_BASE @"https://www.googleapis.com/youtube/v3/"

#define APP_MIXPANEL_TOKEN @"fa41eb7bad08279a065d6dde32c45383"
//#define APP_STORE_URL @"https://itunes.apple.com/us/app/all-hours/id1000983835?ls=1&mt=8"
//#define APP_STORE_ID @"1000983835"
#define APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey]
#define APP_SAVE_DIRECTORY @"group.com.northernspark.doofapp"
#define APP_DEVICE [[[UIDevice currentDevice] systemVersion] floatValue]
#define APP_LANGUAGE [[NSLocale preferredLanguages] objectAtIndex:0]
#define APP_DEVICE_NAME [[UIDevice currentDevice] name];

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
