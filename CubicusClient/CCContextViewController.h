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
//    @private
//    // References to child UIViewController's returned by [CBLayoutElement viewController]
//    // so we can resize them
//    NSMutableArray *_elementViewControllers;
    @private
    BOOL _addedElements;
}

- (id)initWithContext:(CBContext *)context;

@property (readonly, strong) CBContext *context;

@end
