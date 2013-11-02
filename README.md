Pigeon
======
Library for checking new version from App Store, and notify user with local notifications.

#### Features
- VERY EASY TO USE. Just add 2 lines of code, and it works. No server-side needed.
- Checking new version automatically.
- Notify user after finish using the app. No Bother.

#### Demo 

![image](https://github.com/lightory/Pigeon/raw/master/Screenshot.png)

#### Quick Example

``` objective-c
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[Pigeon sharedInstance] startWithAppleId:@"584296227"];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[Pigeon sharedInstance] openInAppStore];
}

@end
```

#### Customize

You can also customize Pigeon as you wish. REMEMBER to set the customizable properties before you call `startWithAppleId:`;

Manage the `latestVersion` yourself, so `Pigeon` won't fetch it from App Store.

``` objective-c
@property (strong, nonatomic) NSString *latestVersion;
```
The message of local notification.

``` objective-c
@property (strong, nonatomic) NSString *updateMessage;
```

The notify interval, default values is one day.

``` objective-c
@property (assign, nonatomic) NSTimeInterval notifyInterval;
```


