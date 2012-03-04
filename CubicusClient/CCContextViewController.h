//
//  CCContextViewController.h
//  Cubicus
//
//  Created by James Potter on 06/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBShared.h"

@interface CCContextViewController : UIViewController {
    UIView *_contextView;
}

- (id)initWithContext:(CBContext *)context;

@property (readonly, strong) CBContext *context;

@end
