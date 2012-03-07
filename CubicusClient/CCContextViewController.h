//
//  CCContextViewController.h
//  Cubicus
//
//  Created by James Potter on 06/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBShared.h"

/*
  For now this class doesn't do much other than create a CBBoxViewController
  for the root element and display it as a subview
*/

@interface CCContextViewController : UIViewController

- (id)initWithContext:(CBContext *)context;

@property (readonly, strong) CBContext *context;
@property (nonatomic, strong, readonly) CBBoxViewController *rootBoxViewController;

@end
