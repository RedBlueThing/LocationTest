//
//  LocationTestAppDelegate.h
//  LocationTest
//
//  Created by Tom Horn on 11/08/10.
//  Copyright Cognethos Pty Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class LocationTestViewController;

@interface LocationTestAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    UIWindow *window;
    LocationTestViewController *viewController;
	NSMutableArray * m_logArray;
	CLLocationManager* m_locManager;
}

- (void) log:(NSString*)msg;
- (NSArray*) getLogArray;
- (void) clearLog;

@property (nonatomic, retain) NSMutableArray * m_logArray;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LocationTestViewController *viewController;

@end

