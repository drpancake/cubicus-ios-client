//
//  CCContextViewController.m
//  Cubicus
//
//  Created by James Potter on 06/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCContextViewController.h"

//UIColor *makeColor(void) {
//    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
//    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
//    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
//    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
//}

@implementation CCContextViewController

@synthesize context;
@synthesize rootElementViewController;

- (id)initWithContext:(CBContext *)theContext
{
    self = [super init];
    if (self) {
        context = theContext;
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
    rootElementViewController.delegate = self;
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
#pragma mark CBElementViewControllerDelegate

- (void)elementViewController:(CBElementViewController *)viewController didSendEvent:(CBEvent *)event
{
    NSLog(@"ContextView got event for element ID %i", event.elementID);
    
    event.contextID = self.context.contextID;
}

@end
