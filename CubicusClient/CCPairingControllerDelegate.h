//
//  CCPairingControllerDelegate.h
//  Cubicus
//
//  Created by James Potter on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCPairingController;

@protocol CCPairingControllerDelegate <NSObject>

// Called with all currently discovered hosts when a new host has been resolved
- (void)pairingController:(CCPairingController *)pairingController didChangeHosts:(NSArray *)hosts;

@end

