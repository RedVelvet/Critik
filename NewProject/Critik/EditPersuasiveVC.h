//
//  EditPersuasiveVC.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Module.h"
#import "QuickGrade.h"
#import "PreDefinedComments.h"
#import "AppDelegate.h"
#import "Speech.h"
#import "AddQuickGradeVC.h"
#import "AddToModuleVC.h"


@interface EditPersuasiveVC : UIViewController <DismissPopoverDelegate>
{
    UIScrollView *beingScrolled_;
}

@property (weak, nonatomic) IBOutlet UITableView *quickTable1;
@property (weak, nonatomic) IBOutlet UITableView *quickTable2;
@property (weak, nonatomic) IBOutlet UITableView *commentsTable;
@property (weak, nonatomic) IBOutlet UITableView *moduleTable;
@property (weak, nonatomic) IBOutlet UILabel *moduleLabel;
@property (strong, nonatomic) UIPopoverController *addQuickGradePopover;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Module *currModule;
@property (strong,nonatomic) Speech *currSpeech;
@property NSInteger sendingButtonTag;
@property (strong, nonatomic) NSMutableArray *modules;
@property (strong, nonatomic) NSMutableArray *quickGrades;
@property (strong, nonatomic) NSMutableArray *preDefinedComments;
@end
