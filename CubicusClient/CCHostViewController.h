//
//  CCHostViewController.h
//  Cubicus
//
//  Created by James Potter on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
  Including these delegates inline induces circular dependency hell
  because Objective-C is a steaming turd
*/
#import "CCPairingControllerDelegate.h"
#import "CCHostViewControllerDelegate.h"

@class CCPairingController;

@interface CCHostViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CCPairingControllerDelegate> {
    NSMutableArray *_hosts;
}

@property (strong, nonatomic, readonly)  UITableView *tableView;
@property (weak, nonatomic) id<CCHostViewControllerDelegate> delegate;

@end