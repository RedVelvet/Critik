//
//  SpeechFinalizeVC.h
//  Critik
//
//  Created by Dalton Decker on 3/3/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "AppDelegate.h"
#import "StudentSelectionVC.h"
#import <DropboxSDK/DropboxSDK.h>
#import "HomeVC.h"
#import "StudentSelectionVC.h"

@interface SpeechFinalizeVC : UIViewController 

@property Student * currentStudent;
@property StudentSpeech * currentStudentSpeech;
@property (strong, nonatomic) DBRestClient *restClient;

@property (weak, nonatomic) IBOutlet UILabel *pointsEarned;
@property (weak, nonatomic) IBOutlet UILabel *penaltyPoints;
@property (weak, nonatomic) IBOutlet UILabel *totalPoints;

-(IBAction)generatePDF:(id)sender;
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath metadata:(DBMetadata*)metadata;

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error;

@end
