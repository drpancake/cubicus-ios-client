//
//  CCContextView.m
//  Cubicus
//
//  Created by James Potter on 06/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCContextView.h"

#import "CBLayoutElement.h"
#import "CBBox.h"

@implementation CCContextView

@synthesize layout;

//UIColor *makeColor(void) {
//    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
//    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
//    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
//    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
//}

- (id)initWithFrame:(CGRect)frame layout:(CBLayout *)theLayout
{
    self = [super initWithFrame:frame];
    if (self) {
        layout = theLayout;
        
        CBBox *box = (CBBox *)layout.rootElement;
        
        CGFloat x = frame.origin.x;
        CGFloat y = frame.origin.y;
        CGFloat h = frame.size.height;
        CGFloat w;
        
        for (CBLayoutElement *el in box.items) {
            // Assuming hbox for now
            
            w = frame.size.width * el.ratio;
            CGRect f = CGRectMake(x, y, w, h);
            x += w;
            
            UIView *v = [el viewWithFrame:f];
            [self addSubview:v];
        }
    }
    return self;
}

@end
