//
//  CCApplicationController.h
//  Cubicus
//
//  Created by James Potter on 06/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBShared.h"

@interface CCApplicationController : UIViewController <CBDeviceClientDelegate> {
    /*
      Keeps track of all current CBApplications. CBClient notifies us when the list
      needs to change (keys are NSNumber application IDs, values are CBApplication objects)
    */
    NSMutableDictionary *_applications;
    
    /*
      Keeps track of current child view controllers. Only actual contexts
      are represented here, as logically an application is a group of contexts.
      Keys are strings in the format <applicationID>_<contextID> and values
      are CCContextController objects
    */
    NSMutableDictionary *_contextViewControllers;
    
    // Default to -1 (i.e. not set)
    NSUInteger _currentApplication;
    NSUInteger _currentContext;
}

- (id)initWithHost:(CBHost *)host;

// User input
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender direction:(UISwipeGestureRecognizerDirection)direction;

// Helper methods
- (void)addSwipeRecognizers;
+ (NSString *)keyForApplication:(NSUInteger)applicationID context:(NSUInteger)contextID;

@property (nonatomic, strong, readonly) CBDeviceClient *client;
@property (nonatomic, weak) id<CBDeviceClientDelegate> delegate;

@end
