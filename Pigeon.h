//  lightory@gmail.com
//  lightory.net
#import <Foundation/Foundation.h>


@interface Pigeon : NSObject
@property (strong, nonatomic) NSString *latestVersion;
@property (strong, nonatomic) NSString *updateMessage;
@property (assign, nonatomic) NSTimeInterval notifyInterval;

+ (instancetype)sharedInstance;
- (void)startWithAppleId:(NSString *)appleId;
- (void)openInAppStore;
@end