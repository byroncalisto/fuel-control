//
//  EditFuelEntryViewController.h
//  FuelControl
//
//  Created by Papío on 3/29/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

@import UIKit;

#import "Vehicle.h"
#import "FuelEntry+FuelEntryExtensions.h"

@interface EditFuelEntryViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) Vehicle *vehicle;
@property (nonatomic, strong) FuelEntry *fuelEntry;

@end
