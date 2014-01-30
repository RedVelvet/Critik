//
//  DetailViewManager.h
//  PresentationFeedback
//
//  Created by Gautham on 7/28/13.
//  Copyright (c) 2013 Gautham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailViewManager : NSObject <UISplitViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, assign) IBOutlet UIViewController *detailViewController;

@end
