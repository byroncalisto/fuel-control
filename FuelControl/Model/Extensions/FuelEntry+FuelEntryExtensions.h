//
//  FuelEntry+FuelEntryExtensions.h
//  FuelControl
//
//  Created by Papío on 3/31/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "FuelEntry.h"

@interface FuelEntry (FuelEntryExtensions)

- (void)storeOdometer:(double)odometer;
- (void)storeTrip:(double)trip;
- (void)storeQuantity:(double)quantity;
- (void)storeCalculatedYield:(double)calculatedYield;
- (void)storeReportedYield:(double)reportedYield;

- (double)convertedOdometer;
- (double)convertedTrip;
- (double)convertedQuantity;
- (double)convertedCalculatedYield;
- (double)convertedReportedYield;

@end
