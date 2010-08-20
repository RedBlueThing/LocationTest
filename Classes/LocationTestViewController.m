//
//  LocationTestViewController.m
//  LocationTest
//
//  Created by Tom Horn on 11/08/10.
//  Copyright Cognethos Pty Ltd 2010. All rights reserved.
//

#import "LocationTestViewController.h"
#import "LogViewController.h"
#import "LocationTestAppDelegate.h"

@implementation LocationDelegate

- (id) initWithLabel:(UILabel*)label
{
	resultsLabel = label;
	return [super init];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{	
	resultsLabel.text = [NSString stringWithFormat:@"(%@) %@ Failed to get location %@", ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) ? @"bg" : @"fg" , resultsLabel.tag == 0 ? @"gps:" : @"sig", [error localizedDescription]];

	LocationTestAppDelegate * appDelegate = (LocationTestAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate log:resultsLabel.text];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setTimeStyle:NSDateFormatterMediumStyle];
		
	resultsLabel.text = [NSString stringWithFormat:@"(%@) %@ Location %.06f %.06f %@", ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) ? @"bg" : @"fg", resultsLabel.tag == 0 ? @"gps:" : @"sig" , newLocation.coordinate.latitude, newLocation.coordinate.longitude, [formatter stringFromDate:newLocation.timestamp]];
	
	LocationTestAppDelegate * appDelegate = (LocationTestAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate log:resultsLabel.text];
}

@end


@implementation LocationTestViewController

@synthesize m_gpsResultsLabel;
@synthesize m_significantResultsLabel;
@synthesize m_significantSwitch;
@synthesize m_gpsSwitch;
@synthesize m_mapSwitch;
@synthesize m_map;

- (void) log:(NSString*)msg andLabel:(UILabel*)label;
{
	LocationTestAppDelegate * appDelegate = (LocationTestAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate log:msg];
	if(label)
		label.text = msg;
}

- (void)viewDidLoad {
		
	m_gpsDelegate = [[LocationDelegate alloc] initWithLabel:m_gpsResultsLabel];
	m_significantDelegate = [[LocationDelegate alloc] initWithLabel:m_significantResultsLabel];	
		
    [super viewDidLoad];
}

- (void) significantOn
{
	[self log:@"Sig tracking on..." andLabel:m_significantResultsLabel];
	
	[m_significantManager release];
	m_significantManager = [[CLLocationManager alloc] init];
	m_significantManager.delegate = m_significantDelegate;

	[m_significantManager startMonitoringSignificantLocationChanges];
}

- (void) significantOff
{
	[self log:@"Sig tracking off..." andLabel:m_significantResultsLabel];
	[m_significantManager stopMonitoringSignificantLocationChanges];
}

- (void) gpsOn
{
	[self log:@"GPS tracking on..." andLabel:m_gpsResultsLabel];
	
	[m_gpsManager release];
	m_gpsManager = [[CLLocationManager alloc] init];
	m_gpsManager.delegate = m_gpsDelegate;

	[m_gpsManager startUpdatingLocation];
}

- (void) gpsOff
{
	[self log:@"GPS tracking off..." andLabel:m_gpsResultsLabel];
	[m_gpsManager stopUpdatingLocation];
}

-(IBAction) actionGps:(id)sender
{
	if (m_gpsSwitch.on)
		[self gpsOn];
	else
		[self gpsOff];
}

-(IBAction) actionSignificant:(id)sender
{
	if (m_significantSwitch.on)
		[self significantOn];
	else
		[self significantOff];
}

-(IBAction) actionMap:(id)sender
{
	[self log:[NSString stringWithFormat:@"map showing location %@", m_mapSwitch.on ? @"on" : @"off"] andLabel:nil];
	m_map.showsUserLocation = m_mapSwitch.on;
}

-(IBAction) actionLog:(id)sender
{
	LogViewController* pNewController=[[[LogViewController alloc] initWithNibName:@"LogViewController" bundle:nil] autorelease];
	[self presentModalViewController:pNewController animated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[m_mapSwitch release];
	[m_gpsResultsLabel release];
	[m_significantResultsLabel release];
	[m_significantSwitch release];
	[m_gpsSwitch release];
	[m_map release];
	[m_gpsManager release];
	[m_significantManager release];
	[m_gpsDelegate release];
	[m_significantDelegate release];
    [super dealloc];
}

@end
