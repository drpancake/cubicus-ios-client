//
//  CCContextView.h
//  Cubicus
//
//  Created by James Potter on 06/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBLayout.h"

@interface CCContextView : UIView

- (id)initWithFrame:(CGRect)frame layout:(CBLayout *)layout;

@property (nonatomic, strong, readonly) CBLayout *layout;

@end
