//
//  MasterViewController.h
//  PresentationFeedback
//
//  Created by Gautham on 7/28/13.
//  Copyright (c) 2013 gautham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface MasterViewController : UITableViewController
{
    UIViewController *SecondViewController;
    UILabel *timerLabel;
    
    UIButton *startButton;
    UIButton *resetButton;
}
@property (nonatomic, strong) UIViewController *SecondViewController;

-(void) createDataFile;

@end
