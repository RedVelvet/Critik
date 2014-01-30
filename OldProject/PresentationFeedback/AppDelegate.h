//
//  AppDelegate.h
//  PresentationFeedback
//
//  Created by Gautham on 7/28/13.
//  Copyright (c) 2013 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DetailViewManager *detailViewManager;

-(void) copyDatabaseIfNeeded;
-(NSString *) getDBPath;


@end
