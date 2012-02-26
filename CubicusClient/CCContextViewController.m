//
//  CCContextViewController.m
//  Cubicus
//
//  Created by James Potter on 06/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCContextViewController.h"
#import "CCContextView.h"


@implementation CCContextViewController

@synthesize context;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (UIView *)view
{
    if (_contextView == nil) {
        // Fit to parent and auto-resize
        CGRect frame = self.parentViewController.view.bounds;
        _contextView = [[CCContextView alloc] initWithFrame:frame layout:self.context.layout];
        _contextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _contextView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void)willMoveToParentViewController:(UIViewController *)parent
//{
//    NSLog(@"%@ willMove", self);
//}
//
//- (void)didMoveToParentViewController:(UIViewController *)parent
//{
//    NSLog(@"%@ didMove", self);
//}

@end
