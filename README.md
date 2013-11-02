Pigeon
======
Library for checking new version from App Store, and notify user with local notifications. 

![image](https://github.com/lightory/Pigeon/raw/master/Screenshot.png)

#### Quick Example

VERY EASY TO USE. Just add 2 lines of code, and it works. No server-side needed.

```
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