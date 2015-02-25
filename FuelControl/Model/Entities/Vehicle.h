//
//  Vehicle.h
//  FuelControl
//
//  Created by Papio on 2/25/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Vehicle : NSManagedObject

@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSSet *fuelEntries;
@end

@interface Vehicle (CoreDataGeneratedAccessors)

- (void)addFuelEntriesObject:(NSManagedObject *)value;
- (void)removeFuelEntriesObject:(NSManagedObject *)value;
- (void)addFuelEntries:(NSSet *)values;
- (void)removeFuelEntries:(NSSet *)values;

@end
