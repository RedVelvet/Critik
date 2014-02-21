//
//  EditSectionVC.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/18/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Section.h"
#import "AppDelegate.h"

@interface EditSectionVC : UIViewController

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSMutableArray *students;
@property (strong, nonatomic) NSMutableArray *students1;
@property (strong, nonatomic) NSMutableArray *students2;
@property (strong, nonatomic) NSMutableArray *students3;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *sectionPicker;
@property (weak, nonatomic) IBOutlet UITableView *studentTableView;
- (IBAction)showStudentsPressed:(id)sender;

@end
