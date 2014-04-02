//
//  StudentOrderPopoverVC.h
//  Critik
//
//  Created by Dalton Decker on 3/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Section.h"
#import "Student.h"  

//@protocol DismissPopoverDelegate
//- (void) dismissPopover:(NSString *)order;
//@end


@interface StudentOrderPopoverVC : UIViewController <UIPopoverControllerDelegate>

@property NSMutableArray * students;
@property Section * currentSection;
@property NSManagedObjectContext * managedObjectContext;

- (IBAction)savePopoverContent:(id)sender;
@end
