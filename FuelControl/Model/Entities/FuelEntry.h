//
//  FuelEntry.h
//  FuelControl
//
//  Created by Papio on 2/25/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vehicle;

@interface FuelEntry : NSManagedObject

@property (nonatomic, retain) NSNumber * odometer;
@property (nonatomic, retain) NSNumber * trip;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * pricePerUnit;
@property (nonatomic, retain) NSNumber * totalPrice;
@property (nonatomic, retain) NSNumber * reportedYield;
@property (nonatomic, retain) NSDecimalNumber * calculatedYield;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Vehicle *vehicle;

@end
