//
//  CCPairingController.h
//  Cubicus
//
//  Created by James Potter on 08/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCHostViewControllerDelegate.h"

/*
  CCPairingController is a container view controller.
  
  By default performs Bonjour discovery/resolve and displays a CCHostViewController
*/

@class CCHostViewController;

@interface CCPairingController : UIViewController <CCHostViewControllerDelegate, NSNetServiceBrowserDelegate, NSNetServiceDelegate> {
    NSNetServiceBrowser *_netServiceBrowser;
    
    // References kept here when they are discovered so ARC doesn't
    // trash them during resolve lookup
    NSMutableArray *_netServices;
    
    // Resolved IP/port pairs
    NSMutableArray *_hosts;
}

@property (nonatomic, strong) CCHostViewController *hostViewController;

@end