//
//  CCContextViewController.m
//  Cubicus
//
//  Created by James Potter on 06/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCContextViewController.h"
#import "CCApplicationController.h"

//UIColor *makeColor(void) {
//    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
//    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
//    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
//    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
//}

@implementation CCContextViewController

@synthesize context;
@synthesize rootElementViewController;
@synthesize eventReceiver;

- (id)initWithContext:(CBContext *)theContext
{
    self = [super init];
    if (self) {
        context = theContext;
        eventReceiver = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    container.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view = container;
    
    // From here view controllers are created recursively downwards
    CBBox *box = (CBBox *)self.context.layout.rootElement;
    rootElementViewController = [box viewControllerForElement];
    rootElementViewController.eventReceiver = self;
    [container addSubview:rootElementViewController.view];
}

- (void)viewDidLayoutSubviews
{
    // Fill our container view
    self.rootElementViewController.view.frame = [self.view bounds];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark -
#pragma mark CBEventReceiver

- (void)sender:(id)sender didFireEvent:(CBEvent *)event
{   
    if ([sender isEqual:self.rootElementViewController]) {
        // Event came upwards from the layout hierarchy, so pass upwards
        event.contextID = self.context.contextID;
        [self.eventReceiver sender:self didFireEvent:event];
    } else if ([sender isKindOfClass:[CCApplicationController class]]) {
        // Otherwise it came from the daemon so pass downwards
        [self.rootElementViewController sender:self didFireEvent:event];
    }
}

@end
