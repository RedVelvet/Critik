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
#import "Student.h"
#import <DropboxSDK/DropboxSDK.h>
#import "AddSectionVC.h"
#import "StudentSpeech.h"
#import "MenuPopoverVC.h"
@interface EditSectionVC : UIViewController <DismissPopoverDelegate>
{
    UIPopoverController* popover;
}

@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *students;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Section *currSection;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *sectionPicker;
@property (weak, nonatomic) IBOutlet UITableView *studentTableView;
@property (nonatomic, readonly) DBRestClient *restClient;
@property (strong, nonatomic) UIPopoverController *addSectionPopover;
@property NSInteger sendingButtonTag;
- (void)downloadFile;
- (IBAction)addStudentPressed:(id)sender;


@end
