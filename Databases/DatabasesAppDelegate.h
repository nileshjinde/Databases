//
//  DatabasesAppDelegate.h
//  Databases
//
//  Created by bhuvan khanna on 31/08/11.
//  Copyright 2011 webonise software solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatabasesViewController;

@interface DatabasesAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet DatabasesViewController *viewController;

@end
