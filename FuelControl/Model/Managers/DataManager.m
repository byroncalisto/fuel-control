//
//  DataManager.m
//  FuelControl
//
//  Created by Papío on 3/11/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import "DataManager.h"

NSString * const DataManagerReadyNotification = @"DataManagerReadyNotification";

@interface DataManager ()

@property (nonatomic, strong) UIManagedDocument *document;

@end

@implementation DataManager

#pragma mark - Singleton initialization

+ (instancetype)instance
{
    static DataManager *dataManager;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        dataManager = [[DataManager alloc] init];
        [dataManager openOrCreateDocument];
    });
    
    return dataManager;
}

#pragma mark - Public Methods

- (void)saveDataObject:(NSManagedObject *)dataObject withCompletionHandler:(void (^)(BOOL))completionHandler
{
    NSError *error;
    
    if (![dataObject.managedObjectContext save:&error]) {
        [self handleDataError:error];
        completionHandler(NO);
    }
    else
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForOverwriting
               completionHandler:completionHandler];
}

- (void)handleDataError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Error"
                                                    message:[NSString stringWithFormat:@"A data error has occurred: %@", error.localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    
    [alert show];
}

#pragma mark - Internal Methods

- (void)openOrCreateDocument
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"FuelDataRepository";
    NSURL *fileUrl = [documentsDirectory URLByAppendingPathComponent:documentName];
    self.document = [[UIManagedDocument alloc] initWithFileURL:fileUrl];
    
    BOOL fileExists = [fileManager fileExistsAtPath:[fileUrl path]];
    
    if (fileExists)
        [self.document openWithCompletionHandler:^(BOOL success) {
            if (success)
                [self documentReady];
            else
                NSLog(@"Could not open %@", [fileUrl path]);
        }];
    else
        [self.document saveToURL:fileUrl
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:^(BOOL success) {
                   if (success)
                       [self documentReady];
                   else
                       NSLog(@"Could not create %@", [fileUrl path]);
               }];
}

- (void)documentReady
{
    if (self.document.documentState == UIDocumentStateNormal) {
        self.context = self.document.managedObjectContext;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DataManagerReadyNotification object:nil];
    }
}

@end
