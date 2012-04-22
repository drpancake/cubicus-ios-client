//
//  CCApplicationController.m
//  Cubicus
//
//  Created by James Potter on 06/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCApplicationController.h"
#import "CCContextViewController.h"
#import "CubicusClient.h"

#import "block_selector.h"

@implementation CCApplicationController

@synthesize client;
@synthesize delegate;

- (id)initWithHost:(CBHost *)host
{
    self = [super init];
    if (self) {
        _applications = [[NSMutableDictionary alloc] init];
        _contextViewControllers = [[NSMutableDictionary alloc] init];
        _currentApplication = -1;
        _currentContext = -1;
        
        // If we don't have a GUID stored yet, generate one and store it
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSString *guid = [def objectForKey:CC_GUID_KEY];
        if (guid == nil) {
            guid = [CBDeviceClient generateGUID];
            [def setObject:guid forKey:CC_GUID_KEY];
        }
        
        client = [[CBDeviceClient alloc] initWithHost:host guid:guid];
        self.client.delegate = self;
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

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // self.view is our container view, CCContextViewController's views get added as subviews
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // Add a spinner to the container so it's visible while
    // we're waiting on CBApplication's to arrive
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    spinner.center = self.view.center;
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    // Swipe gestures
    [self addSwipeRecognizers];

}

- (void)viewDidLoad
{
    // Note: we connect/disconnect as the controller gets/loses focus
    [self.client connect];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
//    [self.client disconnect];
    
    [_applications removeAllObjects];
    _currentApplication = -1;
    _currentContext = -1;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender direction:(UISwipeGestureRecognizerDirection)direction
{
    // Disabled while nothing is displayed
    if (_currentApplication == -1 && _currentContext == -1) {
        return;
    }
    
    // Note: CBDeviceClient will call us as its delegate for actual visual change
    
    // Determine new app/context IDs based on direction
    NSUInteger newApplication = _currentApplication;
    NSUInteger newContext = _currentContext;
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionUp:
            newContext += 1;
            break;
        case UISwipeGestureRecognizerDirectionDown:
            newContext -= 1;
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            newApplication -= 1;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            newApplication += 1;
            break;
    }
    
    // Check the desired application/context combination exists, and if so switch the model
    NSString *key = [CCApplicationController keyForApplication:newApplication context:newContext];
    if ([_contextViewControllers objectForKey:key] != nil) {
        [self.client switchApplication:newApplication context:newContext];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark -
#pragma mark Helper methods

- (void)addSwipeRecognizers
{
    // Ensure swipe methods haven't been added already
    NSString *swipeUpName = [NSString stringWithFormat:@"handleSwipe%i", UISwipeGestureRecognizerDirectionUp];
    if ([self respondsToSelector:NSSelectorFromString(swipeUpName)]) {
        return;
    }
    
    int directions[] = {UISwipeGestureRecognizerDirectionUp, UISwipeGestureRecognizerDirectionDown,
                        UISwipeGestureRecognizerDirectionLeft, UISwipeGestureRecognizerDirectionRight};
    
    for (int i=0; i < 4; i++) {
        int direction = directions[i];
        
        // Type encoding for the block
        const char* encoding = "v@:@";
        void (^methodBlock)(id, UISwipeGestureRecognizer *) = ^(id _self, UISwipeGestureRecognizer *sender) {
            [self handleSwipe:sender direction:direction];
        };
        
        // Add method to this class
        NSString *methodName = [NSString stringWithFormat:@"handleSwipe%i", direction];
        SEL action = createMethod(self, methodName, encoding, (void *)objc_unretainedPointer(methodBlock));
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:action];
        recognizer.direction = direction;
        recognizer.numberOfTouchesRequired = 2; // Avoids interference with canvas elements
        [self.view addGestureRecognizer:recognizer];
    }
}

+ (NSString *)keyForApplication:(NSUInteger)applicationID context:(NSUInteger)contextID;
{
    return [NSString stringWithFormat:@"%i_%i", applicationID, contextID];
}

#pragma mark -
#pragma mark CBEventReceiver

- (void)sender:(id)sender didFireEvent:(CBEvent *)event
{
    // For now we assume only the active application/context can
    // bubble up events, so ensure that this is the case
    NSString *key = [CCApplicationController keyForApplication:_currentApplication context:_currentContext];
    id vc = [_contextViewControllers objectForKey:key];
    NSAssert([sender isEqual:vc], @"Unexpected event from inactive context");
    
    // Attach app ID to the event and send it to the daemon
    event.applicationID = _currentApplication;
    [self.client sendEvent:event];
}

#pragma mark -
#pragma mark CBDeviceClientDelegate

- (void)client:(CBDeviceClient *)client didReceiveApplications:(NSArray *)applications
{
    NSAssert([_applications count] == 0 && [_contextViewControllers count] == 0,
             @"Shouldn't have received apps or created contexts at this point");
    
    for (CBApplication *app in applications) {
        // Keep a reference to CBApplication around
        [_applications setObject:app forKey:[NSNumber numberWithInt:app.applicationID]];
        
        // Create child context controllers, but don't display anything yet
        for (CBContext *context in app.contexts) {
            CCContextViewController *vc = [[CCContextViewController alloc] initWithContext:context];
            vc.eventReceiver = self;
            [self addChildViewController:vc];
            
            NSString *key = [CCApplicationController keyForApplication:app.applicationID context:context.contextID];
            [_contextViewControllers setObject:vc forKey:key];
        }
    }
}

- (void)client:(CBDeviceClient *)client didSwitchApplication:(NSUInteger)applicationID context:(NSUInteger)contextID
{
    // TODO: first switch: pre-load all application default views and slide them in from the left
    
    // Don't do anything if we're already on the requested app/context
    if (_currentApplication == applicationID && _currentContext == contextID) {
        return;
    }
    
    // TODO: figure out the animation, possibilities are: changed context AND app, changed context same app,
    // changed app same 'height' context, first switch to any context/app
    
    // New context we're switching to
    NSString *toKey = [CCApplicationController keyForApplication:applicationID context:contextID];
    CCContextViewController *to = (CCContextViewController *)[_contextViewControllers objectForKey:toKey];
    
    if (_currentContext == -1 && _currentApplication == -1) {
        [self.view addSubview:to.view];
        to.view.frame = self.view.bounds;

    } else {
        NSString *fromKey = [CCApplicationController keyForApplication:_currentApplication context:_currentContext];
        CCContextViewController *from = (CCContextViewController *)[_contextViewControllers objectForKey:fromKey];
        
        // Ensure context view we're moving to fits our container view before animating
        to.view.frame = self.view.bounds;
        
        [self transitionFromViewController:from toViewController:to
                                  duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{}                            
                                completion:nil];
    }
    
    _currentApplication = applicationID;
    _currentContext = contextID;
}

- (void)client:(CBDeviceClient *)client didReceiveEvent:(CBEvent *)event
{
    // Send to the context this event is intended for
    NSString *key = [CCApplicationController keyForApplication:event.applicationID context:event.contextID];
    CCContextViewController *vc = [_contextViewControllers objectForKey:key];
    [vc sender:self didFireEvent:event];
}

@end
