Pigeon
======
Detect new version from App Store, and notify user with local notifications.

## Features
- Just add 3 lines of code, and it works. VERY EASY TO USE.
- Detect new version from App Store automatically. No server-side required.
- Notify user after finish using the app. No Bother.
- Post a notification when finding a new version. You can observe it and notify users in the way you prefer, a UIAlertView for example.

## Demo 

![image](https://github.com/lightory/Pigeon/raw/master/Screenshot.png)

## Quick Example

``` objective-c
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[Pigeon sharedInstance] enableLocalNotification];
    [[Pigeon sharedInstance] startWithAppleId:@"584296227"];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[Pigeon sharedInstance] openInAppStore];
}

@end
```

## Customize

You can also customize Pigeon as you wish. REMEMBER to set the customizable properties before you call `startWithAppleId:`;

Manage the `latestVersion` yourself, so `Pigeon` won't fetch it from App Store.

``` objective-c
@property (strong, nonatomic) NSString *latestVersion;
```

The message of local notification.

``` objective-c
@property (strong, nonatomic) NSString *updateMessage;
```

The country code ( @"us", @"ru" for example ). You should set this code, if your application is not available in all countries. 

``` objective-c
@property (strong, nonatomic) NSString *countyCode;
```

The notify interval. Default values is one day.

``` objective-c
@property (assign, nonatomic) NSTimeInterval notifyInterval;
```

## One More Thing

`Pigeon` will post a notification when finding a new version. You can observe it and notify users in the way you prefer, a UIAlertView for example.

``` objective-c
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewVersionAlertView) name:PigeonDidFindNewVersionNotification object:nil];
```

## Who use Pigeon?

If you're building your applications using `Pigeon`, please let me know! (add your application name & App Store link here and pull reuqest this README.

- Curs Valutar și Convertor: https://itunes.apple.com/us/app/curs-valutar-si-convertor/id548653222


## License

The MIT License (MIT)

Copyright (c) 2013 LIGHT lightory@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
