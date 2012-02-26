//
//  CCPairingController.m
//  Cubicus
//
//  Created by James Potter on 08/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <arpa/inet.h>

#import "CCPairingController.h"
#import "CubicusClient.h"
#import "CCApplicationController.h"
#import "CCHostViewController.h"
#import "CBHost.h"

@implementation CCPairingController

@synthesize hostViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _netServices = [[NSMutableArray alloc] init];
        _hosts = [[NSMutableArray alloc] init];
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
    // Root container view
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    self.view = [[UIView alloc] initWithFrame:frame];
    
    // Initial child view controller (and thus content) is provided
    // by a CCHostViewController, which we pass discovered hosts
    self.hostViewController = [[CCHostViewController alloc] initWithNibName:nil bundle:nil];
    self.hostViewController.delegate = self;
    self.hostViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.hostViewController];
    [self.view addSubview:self.hostViewController.view];
    
    // Start the search
    _netServiceBrowser = [[NSNetServiceBrowser alloc] init]; // Retain
    _netServiceBrowser.delegate = self;
    [_netServiceBrowser searchForServicesOfType:CC_BONJOUR_SERVICE inDomain:@""];
}

- (void)viewDidUnload
{
    // TODO: release child VCs?
    
    [_netServices removeAllObjects];
    [_hosts removeAllObjects];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark NSNetServiceBrowserDelegate

// Called when a Bonjour service is found
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
    // Resolve address(es) for the service
    NSLog(@"didFindService: %@", netService);
    netService.delegate = self;
    [netService resolveWithTimeout:3];
    
    // Retain
    [_netServices addObject:netService];
}

// Service was removed
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
    // TODO: Should alter _hosts at this point
    NSLog(@"didRemoveService: %@", netService);
}

- (void)netServiceDidStop:(NSNetService *)sender
{
    // Release
    _netServiceBrowser = nil;
}

#pragma mark -
#pragma mark NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    // Release
    [_netServices removeObject:sender];
    
    struct sockaddr_in* addr;
    for (NSData* data in [sender addresses]) {
        char addressBuffer[100];
        addr = (struct sockaddr_in*) [data bytes];
        int sockFamily = addr->sin_family;
        if (sockFamily == AF_INET) {
            const char* addressStr = inet_ntop(sockFamily, &(addr->sin_addr), addressBuffer,
                                               sizeof(addressBuffer));
            int port = ntohs(addr->sin_port);
            
            if (addressStr && port) {            
                // Store and refresh table
                CBHost *host = [[CBHost alloc] initWithAddress:[NSString stringWithFormat:@"%s", addressStr]
                                                          port:[NSNumber numberWithInt:port]];
                [_hosts addObject:host];
                
                // Notify host viewer, making a copy of our hosts in case it gets mutated
                NSArray *h = [[NSArray alloc] initWithArray:_hosts]; // Not a deep copy
                [self.hostViewController pairingController:self didChangeHosts:h];
                
            } else {
                NSLog(@"Unable to decode IP/port");
            }
        }   
    }
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"didNotResolve for: %@, error = %@", sender, errorDict);
    [_netServices removeObject:sender];
}

#pragma mark -
#pragma mark CCHostViewControllerDelegate

- (void)hostViewController:(CCHostViewController *)hostViewController didSelectHost:(CBHost *)host
{

    // Application controller takes over as the active child
    CCApplicationController *ac = [[CCApplicationController alloc] initWithHost:host];
    [self addChildViewController:ac];
    
    ac.view.frame = self.view.bounds; // Full screen
    [self transitionFromViewController:self.hostViewController toViewController:ac
                              duration:0.6
                               options:UIViewAnimationOptionTransitionFlipFromRight|UIViewAnimationOptionCurveEaseInOut
                            animations:^{}                            
                            completion:nil];
}

@end
