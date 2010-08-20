//
//  LogViewController.h
//  LocationTest
//
//  Created by Tom Horn on 12/08/10.
//  Copyright 2010 Cognethos Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LogViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView * m_tableView;
}

@property (retain, nonatomic) IBOutlet UITableView * m_tableView;

-(IBAction) actionClose:(id)sender;
-(IBAction) actionClear:(id)sender;

@end
