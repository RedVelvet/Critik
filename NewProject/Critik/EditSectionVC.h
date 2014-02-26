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

@interface EditSectionVC : UIViewController

@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *students;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Section *currSection;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *sectionPicker;
@property (weak, nonatomic) IBOutlet UITableView *studentTableView;
@property (nonatomic, readonly) DBRestClient *restClient;
@property (strong, nonatomic) UIPopoverController *addSectionPopover;
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata;

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error;
- (void)downloadFile;
- (IBAction)addStudentPressed:(id)sender;
- (IBAction)deleteSectionPressed:(id)sender;

@end
