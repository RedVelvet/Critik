//
//  EvaluationViewController.h
//  PresentationFeedback
//
//  Created by Presentation Feedback on 7/29/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <sqlite3.h>
#import <DropboxSDK/DropboxSDK.h>
#import "LandingPageViewController.h"

@interface EvaluationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *pointsEarned;

@property (weak, nonatomic) IBOutlet UILabel *Penalties;

@property (weak, nonatomic) IBOutlet UILabel *TotalPoints;

@property (nonatomic, readonly) DBRestClient *restClient;

- (IBAction)saveToDropbox:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *DropBoxButton;

- (void) didPressLink;
-(void) writeToFile;

- (IBAction)gradeAnotherStudent:(id)sender;
- (IBAction)unlink:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *unlinkBTN;

@end
