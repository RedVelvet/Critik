//
//  SectionViewController.h
//  Presentation Feedback
//
//  Created by Gautham raaz on 12/5/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Constants.h"
#import <DropboxSDK/DropboxSDK.h>
#import "LandingPageViewController.h"

@interface SectionViewController : UIViewController
{
    int index;
}
@property (strong, nonatomic) IBOutlet UITableView *studentsTableView;
@property (strong, nonatomic) IBOutlet UIView *addSectionView;
@property (nonatomic, readonly) DBRestClient *restClient;


-(IBAction)addStudents:(id)sender;
-(IBAction)showStudents:(id)sender;
-(void)downloadFile;

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata;

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error;

- (void)getSections;

@end
