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

@interface EditPersuasiveVC : UIViewController{
    UIScrollView *beingScrolled_;
}

@property (weak, nonatomic) IBOutlet UITableView *quickTable1;
@property (weak, nonatomic) IBOutlet UITableView *quickTable2;
@property (strong, nonatomic) NSMutableArray *modules;
@property (strong, nonatomic) NSMutableArray *quickGrades;
@property (strong, nonatomic) NSMutableArray *preDefinedComments;
@property (weak, nonatomic) IBOutlet UITableView *moduleTable;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Module *currModule;

@end
