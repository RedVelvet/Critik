//
//  EvaluationViewController.m
//  PresentationFeedback
//
//  Created by Presentation Feedback on 7/29/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import "EvaluationViewController.h"
#import "DetailViewManager.h"
#import <DropboxSDK/DropboxSDK.h>


@interface EvaluationViewController ()

@end

@implementation EvaluationViewController
@synthesize DropBoxButton,pointsEarned,Penalties,TotalPoints, restClient,unlinkBTN;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)unlink:(id)sender {
    if ([[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] unlinkAll];
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
        [unlinkBTN setEnabled:NO];
        [DropBoxButton setHidden:NO];
        //        restClient = [[DBRestClient alloc]initWithSession:[DBSession sharedSession]];
        UIAlertView * _alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Account unlinked" delegate:self
                                               cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [_alert show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [DropBoxButton setHidden:NO];
    
    UILabel* stuLabel = (UILabel*)[self.view viewWithTag:200];
    [stuLabel setText:stuName];
    
    [self writeToFile];
    
    [self writeToDB];

    pointsEarned.text = [NSString stringWithFormat:@"%d",pointsEarned1 ];
    
    Penalties.text = [NSString stringWithFormat:@"%d", penalties1];
    
    TotalPoints.text = [NSString stringWithFormat:@"%d", pointsEarned1 - penalties1];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"Evaluation didappear");
    [DropBoxButton setHidden:NO];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"Evaluation viewDidDisappear");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissVC" object:self];
}

-(void) writeToFile
{
    
    NSString *preDefCommnts = [[NSString alloc] init];
    int dataSize=0;
    NSData *data;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    appFile = [NSString stringWithFormat:@"%@_%@_%@.txt",[stuName stringByReplacingOccurrencesOfString:@" " withString:@"_"],speechType,section];
    
    data = [NSData dataWithBytes:[[NSString stringWithFormat:@"Student Name : %@\nSection : %@\nSpeech Type : %@\n", stuName,section,speechType] UTF8String] length:[stuName length]+[speechType length]+[section length]+42];
    
    [data writeToFile:[documentsDirectory stringByAppendingPathComponent:appFile] atomically:YES];
    
    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:[documentsDirectory stringByAppendingPathComponent:appFile]];
    
    for (int s=0 ; s<[moduleTitles count]; s++)
        {
        
            for (int i=0; i<[[allPreCommArray objectAtIndex:s] count]; i++) {
                
                preDefCommnts = [preDefCommnts stringByAppendingFormat:@"->%@\n", [[allPreCommArray objectAtIndex:s] objectForKey:[[[allPreCommArray objectAtIndex:s] allKeys] objectAtIndex:i]]];
            }
        
//            if(!([[quickGradeStrArray objectAtIndex:s] isEqualToString:@"" ]) || !([[commentsArray objectAtIndex:s] isEqualToString:@""]) || !([[pointsArray objectAtIndex:s] isEqualToString:@""]) )
//            {
            
                dataSize = [[moduleTitles objectAtIndex:s] length] + [[quickGradeStrArray objectAtIndex:s] length] + [preDefCommnts length] +[[commentsArray objectAtIndex:s] length]+90;
                
                data = [[NSData alloc] initWithBytes:[[NSString stringWithFormat:@"\n%@\n\nPoints Awarded : %@ \n\nQuick Grades :\n%@\nPredefined Comments : \n%@\nWritten Comments : %@\n", [moduleTitles objectAtIndex:s],[pointsArray objectAtIndex:s], [quickGradeStrArray objectAtIndex:s], preDefCommnts,[commentsArray objectAtIndex:s]] UTF8String] length:dataSize];
                
                [myHandle seekToEndOfFile];
                [myHandle writeData:data];
                [myHandle writeData:[[NSData alloc] initWithBytes:[@"----------------------------------------------------------------------------------\n" UTF8String] length:90]];
//            }
            
            dataSize=0;
            data = nil;
            preDefCommnts = @"";
        }
    
    dataSize = [overTime length] + [dueLastWeek length] + [finalComments length] + [[NSString stringWithFormat:@"%d",pointsEarned1] length] +[duration length]+ 222;
    data = [NSData dataWithBytes:[[NSString stringWithFormat:@"Penalties\n\nPenalized with: %d points \n%@\n%@\n\nFinal Comments : %@\n----------------------------------------------------------------------------------\nPresentation Summary\n\nPoints Earned : %d\nPenalties : %d\nTime-> %@\nTotal Points : %d",penalties1,overTime,dueLastWeek,finalComments,pointsEarned1, penalties1, duration, pointsEarned1-penalties1] UTF8String] length:dataSize];
    
    [myHandle seekToEndOfFile];
    [myHandle writeData:data];
    
    }


-(void) writeToDB
{
    
    sqlite3 *database;
    
    NSString *stmt;
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if(sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK)
    {
        for (int i=0; i<[moduleTitles count]; i++) {
          
            stmt = [NSString stringWithFormat:@"INSERT OR REPLACE INTO SpeechModule (StuID,SpeechType,ModuleName,ScoredModulePoints,WrittenComment) VALUES ('%@','%@','%@','%@','%@')",stuID, speechType, [moduleTitles objectAtIndex:i], [pointsArray objectAtIndex:i], [commentsArray objectAtIndex:i]];
        
            sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
            
            for (int j=0; j<[[allPreCommArray objectAtIndex:i] count]; j++) {
            
                
                stmt = [NSString stringWithFormat:@"INSERT OR REPLACE INTO StudentPredefinedComment (StuID,SpeechType,ModuleName,PredefinedCommentID) VALUES ('%@','%@','%@','%@')",stuID, speechType, [moduleTitles objectAtIndex:i], [[[allPreCommArray objectAtIndex:i] allKeys] objectAtIndex:j]];
                
                sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
            }
            
            for (int k=0; k<[[allQuickArray objectAtIndex:i] count]; k++) {
                
                stmt = [NSString stringWithFormat:@"INSERT OR REPLACE INTO StudentQuickGrade (StuID,SpeechType,ModuleName,QuickGradeID,QuickGradeValue) VALUES ('%@','%@','%@','%@','%@')",stuID, speechType, [moduleTitles objectAtIndex:i], [[[allQuickArray objectAtIndex:i] allKeys] objectAtIndex:k],[[allQuickArray objectAtIndex:i] objectForKey:[[[allQuickArray objectAtIndex:i] allKeys] objectAtIndex:k]]];
                
                sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
            
            }
        }
        
        stmt = [NSString stringWithFormat:@"INSERT OR REPLACE INTO StudentSpeech (StuID,SpeechType,Duration,TotalPoints) VALUES ('%@','%@','%@','%d')", stuID, speechType, duration, pointsEarned1-penalties1];
        
        sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
    }

    sqlite3_close(database);

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)saveToDropbox:(id)sender {
//    if (![[DBSession sharedSession] isLinked]) {
//        [[DBSession sharedSession] linkFromController:self];
//    }
//}



//- (IBAction)saveToDropbox:(id)sender {
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.dropbox.com"]];
    
//    DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
    // Create and configure a new detail view controller appropriate for the selection.
//    UIViewController *firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
//    detailViewManager.detailViewController = firstVC;
//}

//saving file into DropBox

- (void)saveToDropbox:(id)sender {
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
        NSString *warningString=[NSString new];
        warningString=@"Sign-in required before saving the file";
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Information" message:warningString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
    }
    if ([[DBSession sharedSession] isLinked]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        
        NSString *localPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",appFile]];
        NSString *filename = [NSString stringWithFormat:@"%@",appFile];
        
        NSString *destDir = [NSString stringWithFormat:@"/StudentReports/%@/%@",section,speechType];
        [[self restClient] uploadFile:filename toPath:destDir
                        withParentRev:nil fromPath:localPath];
        
        //message displaying file is saved
        NSString *warningString=[NSString new];
        warningString=@"Your file is saved.";
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Message" message:warningString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
    }
}

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    
    [DropBoxButton setHidden:YES];
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"File has been uploaded successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];

}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    
    [DropBoxButton setHidden:NO];
    NSLog(@"File upload failed with error - %@", error);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"File has been uploaded successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


- (IBAction)gradeAnotherStudent:(id)sender
{
    UIAlertView *backAlert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Do you want to move to student list?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [backAlert show];
    [backAlert setTag:1];
}






- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        
        if (buttonIndex==0) {
            
        }
        else
        {
            isBackFromLast = YES;
            isBack = YES;
            started = YES;
            
            [preCommentsDic1 setDictionary:nil];
            [preCommentsDic2 setDictionary:nil];
            [preCommentsDic3 setDictionary:nil];
            [preCommentsDic4 setDictionary:nil];
            [preCommentsDic5 setDictionary:nil];
            [preCommentsDic6 setDictionary:nil];
            [preCommentsDic7 setDictionary:nil];
            
            [commentsArray setArray:nil];
            [pointsArray setArray:nil];
            [quickGradeStrArray setArray: nil];
            
            [quickGradesDic1 setDictionary:nil];
            [quickGradesDic2 setDictionary:nil];
            [quickGradesDic3 setDictionary:nil];
            [quickGradesDic4 setDictionary:nil];
            [quickGradesDic5 setDictionary:nil];
            [quickGradesDic6 setDictionary:nil];
            [quickGradesDic7 setDictionary:nil];
            
            allPreCommArray = [[NSMutableArray alloc] initWithObjects:preCommentsDic1,preCommentsDic2, preCommentsDic3, preCommentsDic4, preCommentsDic5, preCommentsDic6, preCommentsDic7, nil];
            
            allQuickArray = [[NSMutableArray alloc] initWithObjects:quickGradesDic1, quickGradesDic2, quickGradesDic3, quickGradesDic4, quickGradesDic5, quickGradesDic6, quickGradesDic7, nil];
            
            
            for(int i=0;i<10;i++)
            {
                [commentsArray setObject:@"" atIndexedSubscript:i];
                [pointsArray setObject:@"" atIndexedSubscript:i];
                [quickGradeStrArray setObject:@"" atIndexedSubscript:i];
            }
            
           [self dismissViewControllerAnimated:YES completion:nil];
             
        }
    }

}


@end
