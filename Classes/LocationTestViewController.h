//
//  LocationTestViewController.h
//  LocationTest
//
//  Created by Tom Horn on 11/08/10.
//  Copyright Cognethos Pty Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface  LocationDelegate : NSObject <CLLocationManagerDelegate> 
{
	UILabel * resultsLabel;
}

- (id) initWithLabel:(UILabel*)label;

@end


@interface LocationTestViewController : UIViewController <CLLocationManagerDelegate> {
	IBOutlet UILabel * m_gpsResultsLabel;
	IBOutlet UILabel * m_significantResultsLabel;
	IBOutlet UISwitch * m_gpsSwitch;
	IBOutlet UISwitch * m_significantSwitch;
	IBOutlet UISwitch * m_mapSwitch;
	IBOutlet MKMapView * m_map;
	
	LocationDelegate * m_gpsDelegate;
	LocationDelegate * m_significantDelegate;	
	
	// location objects
	CLLocationManager* m_gpsManager;
	CLLocationManager* m_significantManager;
}

-(IBAction) actionGps:(id)sender;
-(IBAction) actionSignificant:(id)sender;
-(IBAction) actionMap:(id)sender;
-(IBAction) actionLog:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel * m_gpsResultsLabel;
@property (retain, nonatomic) IBOutlet UILabel * m_significantResultsLabel;
@property (retain, nonatomic) IBOutlet UISwitch * m_gpsSwitch;
@property (retain, nonatomic) IBOutlet UISwitch * m_significantSwitch;
@property (retain, nonatomic) IBOutlet UISwitch * m_mapSwitch;
@property (retain, nonatomic) IBOutlet MKMapView * m_map;

@end

