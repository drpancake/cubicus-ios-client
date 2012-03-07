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

- (id)initWithContext:(CBContext *)theContext
{
    self = [super init];
    if (self) {
        context = theContext;
        _addedElements = NO;
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
    /*
      Create the container view here, but wait until its been resized (i.e.
      viewDidLayoutSubviews: is called) before adding layout subviews, as they
      rely on dimensions
    */
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    container.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view = container;
    
    // TEMP
    container.backgroundColor = [UIColor redColor];
}

- (void)viewDidLayoutSubviews
{
    if (!_addedElements) {
        CGRect frame = self.view.frame;
        CGFloat x = frame.origin.x;
        CGFloat y = frame.origin.y;
        CGFloat h = frame.size.height;
        CGFloat w;

        CBBox *box = (CBBox *)self.context.layout.rootElement;
        for (CBLayoutElement *el in box.items) {
            // Assuming hbox for now
            
            w = frame.size.width * el.ratio;
            CGRect f = CGRectMake(x, y, w, h);
            x += w;
            
            // Stubbed
            UIView *v = [[UIView alloc] initWithFrame:f];
            UILabel *labelView = [[UILabel alloc] initWithFrame:v.bounds];
            labelView.text = [NSString stringWithFormat:@"<%@>", [el class]];
            [v addSubview:labelView];
            
            [self.view addSubview:v];
        }
        
        _addedElements = YES;
    }
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
