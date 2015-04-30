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

@protocol EditFuelEntryDelegate;

@interface EditFuelEntryViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) Vehicle *vehicle;
@property (nonatomic, strong) FuelEntry *fuelEntry;
@property (nonatomic, weak) id<EditFuelEntryDelegate> delegate;

@end

@protocol EditFuelEntryDelegate <NSObject>

- (void)fuelEntryDidSave:(EditFuelEntryViewController *)editFuelEntryVC;

@end