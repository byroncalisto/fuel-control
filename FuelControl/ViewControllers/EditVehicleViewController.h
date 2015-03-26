//
//  EditVehicleViewController.h
//  FuelControl
//
//  Created by Papío on 3/12/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

@import UIKit;
@import CoreData;

#import "Vehicle.h"

@protocol EditVehicleViewDelegate;

@interface EditVehicleViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) Vehicle *vehicle;
@property (nonatomic, weak) id<EditVehicleViewDelegate> delegate;

@end

@protocol EditVehicleViewDelegate <NSObject>

- (void)vehicleDidSave:(EditVehicleViewController *)editVehicleVC;

@end
