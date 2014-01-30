//
//  LandingPageViewController.h
//  PresentationFeedback
//
//  Created by Gautham raaz on 10/27/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Constants.h"
#import "DetailViewManager.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "SectionViewController.h"

@interface LandingPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIPickerView *sectionPicker;
@property (strong, nonatomic) IBOutlet UITableView *studentTableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic, readonly) DBRestClient *restClient;


- (IBAction)editButtonPressed:(id)sender;
- (IBAction)donePressed:(id)sender;
- (IBAction)addPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (void)getstudentList;

@property (strong, nonatomic) IBOutlet UILabel *editLabel;

@property (strong, nonatomic) IBOutlet UILabel *speechTypeLabel;

//- (IBAction)download:(UIButton *)sender;

@end
