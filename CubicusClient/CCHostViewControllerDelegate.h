//
//  CCHostViewControllerDelegate.h
//  Cubicus
//
//  Created by James Potter on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCHostViewController;
@class CBHost;

@protocol CCHostViewControllerDelegate <NSObject>

// Called when the user attempts to connect to a host
- (void)hostViewController:(CCHostViewController *)hostViewController didSelectHost:(CBHost *)host;

@end
