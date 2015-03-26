//
//  DataManager.h
//  FuelControl
//
//  Created by Papío on 3/11/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

@import Foundation;
@import CoreData;
@import UIKit;

@interface DataManager : NSObject

extern NSString * const DataManagerReadyNotification;

@property (nonatomic, strong) NSManagedObjectContext *context;

+ (instancetype)instance;
- (void)saveDataObject:(NSManagedObject *)dataObject withCompletionHandler:(void (^)(BOOL success))completionHandler;
- (void)handleDataError:(NSError *)error;

@end
