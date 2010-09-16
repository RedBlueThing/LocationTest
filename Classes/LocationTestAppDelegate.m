//
//  LocationTestAppDelegate.m
//  LocationTest
//
//  Created by Tom Horn on 11/08/10.
//  Copyright Cognethos Pty Ltd 2010. All rights reserved.
//

#import "LocationTestAppDelegate.h"
#import "LocationTestViewController.h"

@implementation LocationTestAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize m_logArray;

#pragma mark -
#pragma mark Application lifecycle

- (NSString*)locationPath
{
	NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	return [path stringByAppendingPathComponent:@"locationPath.txt"];
}

- (id)init
{
	return [super init];
}

- (void) clearLog
{
	NSString * content = @"";
	NSString * fileName = [self locationPath];
	[content writeToFile:fileName 
			atomically:NO 
			encoding:NSStringEncodingConversionAllowLossy 
			error:nil];
}

- (NSArray*) getLogArray
{
	NSString * fileName = [self locationPath];
	NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
										usedEncoding:nil
										error:nil];
	NSMutableArray * array = (NSMutableArray *)[content componentsSeparatedByString:@"\n"];
	NSMutableArray * newArray = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < [array count]; i++)
	{
		NSString * item = [array objectAtIndex:i];
		if ([item length])
			[newArray addObject:item];
	}
	return (NSArray*)newArray;
}

- (void) log:(NSString*)msg
{	
	NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setTimeStyle:NSDateFormatterMediumStyle];
	NSString * logMessage = [NSString stringWithFormat:@"%@ %@", [formatter stringFromDate:[NSDate date]], msg];
		
	NSString * fileName = [self locationPath];
	FILE * f = fopen([fileName cString], "at");
	fprintf(f, "%s\n", [logMessage cString]);
	fclose (f);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	[self log:[NSString stringWithFormat:@"Background Fail %@", [error localizedDescription]]];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	[self log:[NSString stringWithFormat:@"Background location %.06f %.06f %@" , newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.timestamp]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customizatio-n after application launch.
	id locationValue = [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey];
	if (locationValue)
	{
		// create a new manager and start checking for sig changes
		[self log:@"didFinishLaunchingWithOptions location key"];
		m_locManager = [[CLLocationManager alloc] init];
		[self log:@"didFinishLaunchingWithOptions created manager"];
		m_locManager.delegate = self;
		[self log:@"didFinishLaunchingWithOptions set delegate"];
		[m_locManager startMonitoringSignificantLocationChanges];
		[self log:@"didFinishLaunchingWithOptions monitoring sig changes"];
		return YES;
	}
	
	[self log:@"didFinishLaunchingWithOptions"];	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[self log:@"applicationWillResignActive"];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:viewController.m_significantSwitch.on forKey:@"significant"];
	[userDefaults synchronize];
}                


- (void)applicationDidEnterBackground:(UIApplication *)application {
	[self log:@"applicationDidEnterBackground"];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

	[self log:@"applicationWillEnterForeground"];
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	[self log:@"applicationDidBecomeActive"];
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */

	// if we don't have any subviews on the main window
	if (![window.subviews count])
	{
		// Add the view controller's view to the window and display.
		[window addSubview:viewController.view];
		[window makeKeyAndVisible];
		
		NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
		viewController.m_significantSwitch.on = [userDefaults boolForKey:@"significant"];
		if (viewController.m_significantSwitch.on)
			[viewController actionSignificant:nil];
	}
}


- (void)applicationWillTerminate:(UIApplication *)application {
	[self log:@"applicationWillTerminate"];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[m_locManager release];
	[m_logArray release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
