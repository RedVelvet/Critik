//
//  Edit_SecondViewController.h
//  Presentation Feedback
//
//  Created by Gautham raaz on 11/28/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Constants.h"
#import "AppDelegate.h"

@interface Edit_SecondViewController : UIViewController
{
    int yPos1;
    int yPos2;
    int y2;
    int y1;
    
}
- (IBAction)addButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)checkButtonClicked:(id)sender;

/*
 - (IBAction)addButtonPressed:(id)sender;
 - (IBAction)deleteButtonPressed:(id)sender;
 - (IBAction)doneButtonPressed:(id)sender;
 - (IBAction)checkButtonClicked:(id)sender;
 - (IBAction)cancelButtonPressed:(id)sender;
 */
@property (strong, nonatomic) IBOutlet UIView *addQuickView;

@property (strong, nonatomic) IBOutlet UIView *addPreCommentView;

//@property (strong, nonatomic) IBOutlet UIView *addPreCommentView;


@end
