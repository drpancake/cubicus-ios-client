//
//  CCHostViewController.m
//  Cubicus
//
//  Created by James Potter on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCHostViewController.h"
#import "CBShared.h"

@implementation CCHostViewController

@synthesize tableView;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
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
    tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.view = tableView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate hostViewController:self didSelectHost:[_hosts objectAtIndex:indexPath.row]];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_hosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CBHost *host = [_hosts objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@", host.address, host.port];
    return cell;
}

#pragma mark -
#pragma mark CCPairingControllerDelegate

- (void)pairingController:(CCPairingController *)pairingController didChangeHosts:(NSArray *)hosts
{
    [_hosts removeAllObjects];
    [_hosts addObjectsFromArray:hosts];
    [self.tableView reloadData];
}

@end
