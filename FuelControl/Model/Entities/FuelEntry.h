//
//  FuelEntry.h
//  FuelControl
//
//  Created by Papío on 4/6/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vehicle;

@interface FuelEntry : NSManagedObject

@property (nonatomic, retain) NSNumber * calculatedYield;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * odometer;
@property (nonatomic, retain) NSNumber * pricePerUnit;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * reportedYield;
@property (nonatomic, retain) NSNumber * totalPrice;
@property (nonatomic, retain) NSNumber * trip;
@property (nonatomic, retain) Vehicle *vehicle;

@end
