//
//  FuelingsTableViewController.h
//  FuelControl
//
//  Created by Papío on 3/26/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

@import UIKit;

#import "Vehicle.h"
#import "EditFuelEntryViewController.h"

@interface FuelingsTableViewController : UITableViewController <EditFuelEntryDelegate>

@property (nonatomic, strong) Vehicle *vehicle;

@end
