// The MIT License (MIT)
//
// Copyright (c) 2013 LIGHT lightory@gmail.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "Pigeon.h"


@interface Pigeon()
@property (assign, nonatomic) NSString *appleId;
@end


@implementation Pigeon

+ (instancetype)sharedInstance
{
    static Pigeon *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[[self class] alloc] init];
        instance.updateMessage = [NSString stringWithFormat:[instance localizedStringForKey:@"UpdateMessage"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
        instance.notifyInterval = 3600 * 24;
	});
	return instance;
}

- (void)startWithAppleId:(NSString *)appleId
{
    self.appleId = appleId;
    
    if (![self shouldCheck]) return;
    
    if (!self.latestVersion) {
        dispatch_async(dispatch_queue_create("Pigeon", NULL), ^{
            [self fetchLatestVersionFromAppStore];
            if (![self isLatestVersion]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:PigeonDidFindNewVersionNotification object:nil];
            }
        });
    } else {
        if (![self isLatestVersion]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PigeonDidFindNewVersionNotification object:nil];
        }
    }
}

- (void)openInAppStore
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(openInAppStore) withObject:nil waitUntilDone:YES];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", self.appleId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark
- (BOOL)shouldCheck
{
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval lastCheckedTimeInterval = [[NSUserDefaults standardUserDefaults] floatForKey:@"PIGEON_LAST_CHECKED_TIME_INTERVAL"];
    if (currentTimeInterval <= lastCheckedTimeInterval + self.notifyInterval) return NO;
    
    [[NSUserDefaults standardUserDefaults] setFloat:currentTimeInterval forKey:@"PIGEON_LAST_CHECKED_TIME_INTERVAL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

- (BOOL)isLatestVersion
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSArray *latestVersionArray = [self.latestVersion componentsSeparatedByString:@"."];
    NSArray *currentVersionArray = [currentVersion componentsSeparatedByString:@"."];
    
    for (NSInteger i = 0; i < latestVersionArray.count; i++) {
        if (currentVersionArray.count <= i) return NO;
        if ([latestVersionArray[i] intValue] > [currentVersionArray[i] intValue]) return NO;
        if ([latestVersionArray[i] intValue] < [currentVersionArray[i] intValue]) return YES;
        if ([latestVersionArray[i] intValue] == [currentVersionArray[i] intValue]) continue;
    }
    
    return YES;
}

- (void)fetchLatestVersionFromAppStore
{
    NSError *error = nil;
    NSString *countryCode = self.countyCode.length ? [self.countyCode stringByAppendingString:@"/"] : @"";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/%@lookup?id=%@", countryCode, self.appleId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (response && !error) {
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        if (!infoDic[@"results"]) return;
        if ([infoDic[@"results"] count] == 0) return;
        self.latestVersion = infoDic[@"results"][0][@"version"];
    }
}

#pragma mark - Local Notification
- (void)enableLocalNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addObserverOnApplicationDidEnterBackground) name:PigeonDidFindNewVersionNotification object:nil];
}

- (void)addObserverOnApplicationDidEnterBackground
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scheduleUpdateNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)scheduleUpdateNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [[[NSDate alloc] init] dateByAddingTimeInterval:3];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = self.updateMessage;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - Localization
- (NSString *)localizedStringForKey:(NSString *)key
{
    return [[self localizedBundle] localizedStringForKey:key value:nil table:nil];
}

- (NSBundle *)localizedBundle
{
    static NSBundle *localizedBundle = nil;
    if (localizedBundle == nil) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Pigeon" ofType:@"bundle"];
        localizedBundle = [NSBundle bundleWithPath:bundlePath] ?: [NSBundle mainBundle];
        
        for (NSString *language in [NSLocale preferredLanguages]) {
            if ([[localizedBundle localizations] containsObject:language]) {
                bundlePath = [localizedBundle pathForResource:language ofType:@"lproj"];
                localizedBundle = [NSBundle bundleWithPath:bundlePath];
                break;
            }
        }
        
        if (localizedBundle == nil) {
            bundlePath = [localizedBundle pathForResource:@"en" ofType:@"lproj"];
            localizedBundle = [NSBundle bundleWithPath:bundlePath];
        }
    }
    
    return localizedBundle;
}

@end